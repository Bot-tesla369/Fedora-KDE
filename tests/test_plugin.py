"""Package contracts and diagnostic behavior without querying real system services."""

import json
import os
import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPT = ROOT / 'src/fedora-diagnostico.sh'
BASH = shutil.which('bash')
SKILLS = {
    'fedora-diagnostico', 'fedora-operaciones', 'fedora-seguridad-rendimiento',
    'kde-escritorio', 'kde-terminales', 'kde-wayland-diagnostico',
}


class PackageTests(unittest.TestCase):
    def test_manifest_identity_and_skill_discovery(self):
        generic = json.loads((ROOT / 'plugin.json').read_text())
        host = json.loads((ROOT / '.codex-plugin/plugin.json').read_text())
        for field in ('name', 'version', 'description', 'author', 'keywords'):
            self.assertEqual(generic[field], host[field])
        self.assertEqual(host['name'], 'fedora-kde')
        self.assertRegex(host['version'], r'^\d+\.\d+\.\d+$')
        self.assertEqual(host['interface'], generic['extensions']['com.openai']['interface'])
        self.assertEqual(host['interface']['displayName'], 'Fedora-KDE')
        self.assertLessEqual(len(host['interface']['shortDescription']), 30)
        self.assertEqual((ROOT / host['skills']).resolve(), ROOT / 'skills')
        self.assertNotIn('email', host['author'])
        self.assertEqual({p.parent.name for p in (ROOT / 'skills').glob('*/SKILL.md')}, SKILLS)

    def test_marketplace_resolves_native_plugin_at_repository_root(self):
        catalogs = list(ROOT.rglob('marketplace.json'))
        self.assertEqual(catalogs, [ROOT / '.agents/plugins/marketplace.json'])
        catalog = json.loads(catalogs[0].read_text())
        self.assertEqual(catalog['name'], 'fedora-kde-marketplace')
        self.assertEqual(len(catalog['plugins']), 1)
        entry = catalog['plugins'][0]
        self.assertEqual(entry['name'], 'fedora-kde')
        self.assertEqual(entry['source']['source'], 'local')
        self.assertEqual((ROOT / entry['source']['path']).resolve(), ROOT)
        self.assertTrue((ROOT / '.codex-plugin/plugin.json').is_file())
        self.assertEqual(entry['policy']['installation'], 'AVAILABLE')
        self.assertEqual(entry['policy']['authentication'], 'ON_INSTALL')

    def test_skills_and_shared_protocol_are_reachable(self):
        for path in ROOT.rglob('*.md'):
            text = path.read_text()
            if path.name == 'SKILL.md':
                self.assertTrue(text.startswith('---\nname: ' + path.parent.name + '\n'))
                self.assertRegex(text, r'(?m)^description: .+')
                self.assertIn('contexto-y-fuentes.md', text)
            for target in re.findall(r'\]\(([^)]+)\)', text):
                if '://' not in target and not target.startswith('#'):
                    self.assertTrue((path.parent / target.split('#')[0]).exists(), (path, target))
        reference = ROOT / 'skills/fedora-diagnostico/references/contexto-y-fuentes.md'
        self.assertEqual((reference.parent / '../../../src/fedora-diagnostico.sh').resolve(), SCRIPT)

    def test_no_device_profile_or_local_capture_is_packaged(self):
        # Avoid publishing real absolute home paths, contact details and report files.
        for path in ROOT.rglob('*'):
            if not path.is_file() or any(part in {'.git', '__pycache__'} for part in path.relative_to(ROOT).parts):
                continue
            self.assertNotIn(path.suffix, {'.log', '.journal', '.core', '.dump', '.bak'})
            text = path.read_text()
            self.assertNotRegex(text, r'/home/[A-Za-z0-9_.-]+/')
            self.assertNotRegex(text, r'[\w.+-]+@[\w.-]+\.[a-zA-Z]{2,}')


class DiagnosticTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='fedora-kde-test-')
        self.addCleanup(self.temp.cleanup)
        self.directory = Path(self.temp.name)
        self.bin = self.directory / 'bin'
        self.bin.mkdir()
        self.log = self.directory / 'calls'
        self.env = os.environ.copy()
        self.env.update(PATH=str(self.bin), MOCK_CALLS=str(self.log),
                        XDG_SESSION_TYPE='wayland', XDG_CURRENT_DESKTOP='KDE')
        self.env.pop('BASH_ENV', None)
        self.env.pop('ENV', None)
        self.mock('timeout', 'shift 2\nexec "$@"\n')
        (self.bin / 'bash').symlink_to(BASH)
        self.mock('uname', 'printf "test-kernel-or-arch\\n"\n')
        self.mock('rpm', 'printf "test-plasma-package\\n"\n')
        self.mock('free', 'printf "test-memory\\n"\n')
        self.mock('swapon', 'printf "TYPE SIZE USED PRIO\\npartition 8G 0B -2\\n"\n')
        self.mock('df', 'printf "Size Used Avail Use%%\\n100G 40G 60G 40%%\\n"\n')
        self.mock('findmnt', 'printf "btrfs\\n"\n')
        self.mock('systemd-analyze', 'printf "Startup finished in test seconds\\n"\n')
        self.mock('getenforce', 'printf "Enforcing\\n"\n')
        self.mock('systemctl', 'printf "LoadState=loaded\\nActiveState=active\\n"\n')
        self.mock('lspci', 'printf "00:01.0 VGA compatible controller: Test GPU\\n\\tKernel driver in use: testgpu\\n00:02.0 Network controller: OMIT-NETWORK\\n\\tKernel driver in use: private\\n"\n')
        awk = shutil.which('awk')
        if awk:
            (self.bin / 'awk').symlink_to(awk)

    def mock(self, name, body):
        path = self.bin / name
        path.write_text('#!' + BASH + '\n' +
                        'printf "%s\\n" "' + name + ' $*" >> "$MOCK_CALLS"\n' + body)
        path.chmod(0o755)

    def run_script(self, *args):
        return subprocess.run([BASH, str(SCRIPT), *args], env=self.env,
                              capture_output=True, text=True, timeout=15)

    def calls(self):
        return self.log.read_text() if self.log.exists() else ''

    def test_help_and_invalid_arguments_do_not_query_system(self):
        self.assertEqual(self.run_script('--help').returncode, 0)
        for args in [('--section',), ('--section', 'bad'), ('--bad',), ('--help', 'extra')]:
            with self.subTest(args=args):
                self.assertEqual(self.run_script(*args).returncode, 2)
        self.assertEqual(self.calls(), '')

    def test_default_context_is_small(self):
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn('Reported session: wayland', result.stdout)
        self.assertIn('Reported desktop: KDE', result.stdout)
        self.assertIn('test-plasma-package', result.stdout)
        self.assertIn('timeout --kill-after=2s 10s', self.calls())
        for command in ('free ', 'lspci ', 'systemctl ', 'systemd-analyze ', 'swapon '):
            self.assertNotIn(command, self.calls())

    def test_graphics_excludes_unrelated_devices(self):
        if not shutil.which('awk'):
            self.skipTest('awk not installed on test runner')
        result = self.run_script('--section', 'graphics')
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn('Test GPU', result.stdout)
        self.assertIn('testgpu', result.stdout)
        self.assertNotIn('OMIT-NETWORK', result.stdout)
        self.assertNotIn('driver in use: private', result.stdout)

    def test_all_queries_use_safe_targeted_arguments(self):
        if not shutil.which('awk'):
            self.skipTest('awk not installed on test runner')
        result = self.run_script('--section', 'all')
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn('TYPE,SIZE,USED,PRIO', self.calls())
        self.assertIn('--output=size,used,avail,pcent', self.calls())
        self.assertIn('systemctl show firewalld.service', self.calls())
        self.assertNotIn('systemctl --failed', self.calls())
        self.assertNotRegex(self.calls(), r'journalctl|sudo|curl|wget|dnf |hostname')

    def test_remote_connection_values_are_not_disclosed(self):
        self.env['SSH_CONNECTION'] = 'PRIVATE-REMOTE-ADDRESS PRIVATE-PORT'
        result = self.run_script()
        self.assertIn('SSH access detected', result.stdout)
        self.assertNotIn('PRIVATE-REMOTE-ADDRESS', result.stdout)
        self.assertNotIn('PRIVATE-PORT', result.stdout)

    def test_missing_tool_is_reported_without_installing(self):
        (self.bin / 'rpm').unlink()
        result = self.run_script()
        self.assertEqual(result.returncode, 1)
        self.assertIn('Unavailable: rpm', result.stdout)
        self.assertNotIn('dnf', self.calls())

    def test_service_query_failure_is_not_reported_as_healthy(self):
        self.mock('systemctl', 'printf "test bus error\\n" >&2\nexit 1\n')
        result = self.run_script('--section', 'security')
        self.assertEqual(result.returncode, 1)
        self.assertIn('No verifiable result', result.stdout)
        self.assertIn('status 1', result.stdout)
        self.assertNotIn('ActiveState=active', result.stdout)

    def test_timeout_is_visible_and_report_is_partial(self):
        self.mock('timeout', 'exit 124\n')
        result = self.run_script()
        self.assertEqual(result.returncode, 1)
        self.assertIn('status 124', result.stdout)


if __name__ == '__main__':
    unittest.main(verbosity=2)
