#!/usr/bin/env bash
# Local package checks using simulated queries and temporary files.
set -euo pipefail
plugin_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
bash -n "$plugin_root/src/fedora-diagnostico.sh"
bash -n "$plugin_root/tests/test-plugin.sh"
PYTHONDONTWRITEBYTECODE=1 python3 "$plugin_root/tests/test_plugin.py"
