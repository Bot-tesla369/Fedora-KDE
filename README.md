# Fedora-KDE

An English-language plugin for administering, diagnosing, and customizing Fedora with KDE Plasma. It combines Edward-Fedora and Edward-KDE capabilities in a public package without hardware profiles or personal user settings.

## 1. Objective

Resolve compatibility, stability, performance, and desktop usability issues using evidence from the current system. The agent inspects the environment when necessary, proposes or applies the relevant change, and verifies the result.

## 2. Features

| Skill | Responsibility |
| --- | --- |
| `fedora-diagnostico` | Boot, services, devices, networking, audio, and permissions. |
| `fedora-operaciones` | RPM/DNF, Flatpak, repositories, updates, and firmware; distinguishes traditional Fedora from Kinoite/OSTree. |
| `fedora-seguridad-rendimiento` | Measurements, resources, boot, battery, temperature, SELinux, and firewall. |
| `kde-escritorio` | Panels, widgets, themes, colors, fonts, shortcuts, and appearance. |
| `kde-terminales` | Konsole, profiles, shells, prompts, Fastfetch, ASCII art, and supported images. |
| `kde-wayland-diagnostico` | Plasma/KWin, widget sensors, scaling, monitors, and desktop failures. |

All skills share a [context, compatibility, and privacy protocol](skills/fedora-diagnostico/references/contexto-y-fuentes.md). Existing identifiers and paths are retained for compatibility; all instructions and output messages are in English. Responses default to English unless the user requests another language.

## 3. Requirements

Codex or another skills-compatible agent with access to the plugin files. Automated system queries need a shell tool connected to the affected machine; the plugin provides neither remote access nor privileged access. Without a shell, it provides commands to run locally.

The optional script requires Bash and common Fedora tools. It uses `timeout` to bound queries and reports missing tools without installing them. Package checks require Bash and Python 3 and simulate commands instead of inspecting real services or hardware. Web research requires browsing access.

## 4. Installation and usage

The plugin identity is **`fedora-kde`**, version **2.0.2**. It does not automatically replace `edward-fedora` or `edward-kde`: install this package, verify that its six skills appear, and then remove the old plugins through plugin management if no longer needed.

### Add from GitHub without a password

In **Add plugin marketplace**, use either:

- Repository shorthand: `Bot-tesla369/Fedora-KDE` (no `.git` suffix).
- Full clone URL: `https://github.com/Bot-tesla369/Fedora-KDE.git`.

Set the Git reference to `main` and leave sparse paths empty. Do not enter `Bot-tesla369/Fedora-KDE.git` as shorthand: the tested client appends `.git`, producing `Fedora-KDE.git.git` and a GitHub credential prompt. Cancel that prompt and correct the source. This public repository needs no GitHub credentials for cloning. Plugin authentication policy does not control Git clone authentication. A local Git URL rewrite can map the exact malformed clone URL to the correct public repository; this is a per-machine compatibility workaround, not a change to GitHub authentication.

CLI equivalent:

```bash
codex plugin marketplace add https://github.com/Bot-tesla369/Fedora-KDE.git --ref main
codex plugin add fedora-kde@fedora-kde-marketplace
```

For local installation, add the checked-out repository folder as the marketplace source. The catalog is at `.agents/plugins/marketplace.json`; its `./` source resolves to the repository root. The native Codex manifest is `.codex-plugin/plugin.json`, with an Agent Plugins 1.0 manifest at `plugin.json`. The generic manifest omits the optional remote `$schema` declaration so editors do not depend on an external schema download; package checks and a native Codex installation validate the package locally.

Example requests:

- “This error appeared after updating Fedora KDE; investigate and fix it.”
- “Measure why Plasma uses so much memory before changing settings.”
- “Configure Konsole and a temperature indicator compatible with my Plasma version.”

For manual inspection from the plugin root:

```bash
bash src/fedora-diagnostico.sh --help
bash src/fedora-diagnostico.sh
bash src/fedora-diagnostico.sh --section graphics
```

Other sections are `resources`, `security`, and `all`; each includes base context. The script only reads local data and prints to standard output. It uses no network, sudo, installers, or report files. It does not collect logs or deliberately query hostnames, IP/MAC addresses, UUIDs, or serial numbers. Versions and hardware models remain technical device information; review output before sharing it. Exit 1 means a partial report, not necessarily a fault; exit 0 does not certify a healthy system.

## 5. Architecture

```txt
[Request and symptom]
        ↓
[Primary skill and shared protocol]
        ↓
[Minimum context: host, edition, version, session]
        ↓
[Evidence and applicable documentation]
        ├── Incomplete → [Targeted query and revised hypothesis]
        └── Sufficient → [Change within authorized scope]
                                  ↓
                          [Functional verification]
                            ├── Fails  → [Rollback and new hypothesis]
                            └── Passes → [Document result and recovery]
```

Traditional Fedora and Kinoite require different administration paths. An SSH session, Toolbx, or container does not establish the state of the host desktop. Versions are queried rather than fixed in the package.

## 6. Sources, privacy, and limitations

The protocol links to [Fedora KDE SIG](https://fedoraproject.org/wiki/KDE), [Fedora Docs](https://docs.fedoraproject.org/), [Kinoite](https://docs.fedoraproject.org/en-US/fedora-kinoite/), [KDE manuals](https://docs.kde.org/), and [Konsole](https://docs.kde.org/stable_kf6/en/konsole/konsole/index.html). Match documentation to the installed version; a link does not establish compatibility, and some pages block automated clients.

Do not publish machine output, logs, secrets, or personal configuration backups. Keep reports and backups outside the plugin. `.gitignore` reduces accidental additions but does not remove tracked files; review staged changes before committing.

Do not apply universal tuning, restarts, or bulk updates as routine maintenance. Boot, storage, and firmware need a specific assessment. This package does not certify security or replace real-system verification. Editing this folder does not update cached installations or uninstall previous plugins.

## 7. File index and checks

```txt
Fedora-KDE/
├── README.md
├── plugin.json
├── .codex-plugin/plugin.json
├── .agents/plugins/marketplace.json
├── skills/
│   ├── fedora-diagnostico/
│   │   ├── SKILL.md
│   │   └── references/contexto-y-fuentes.md
│   ├── fedora-operaciones/SKILL.md
│   ├── fedora-seguridad-rendimiento/SKILL.md
│   ├── kde-escritorio/SKILL.md
│   ├── kde-terminales/SKILL.md
│   └── kde-wayland-diagnostico/SKILL.md
├── src/fedora-diagnostico.sh
└── tests/
    ├── test-plugin.sh
    └── test_plugin.py
```

Run `bash tests/test-plugin.sh` to check syntax, metadata, catalog paths, internal links, and script behavior with simulated commands, missing tools, and query failures. These checks do not substitute for host installation or testing every function on real hardware.
