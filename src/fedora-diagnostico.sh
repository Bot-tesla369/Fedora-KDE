#!/usr/bin/env bash
# Local queries without sudo, network access, installations, or output files.
set -uo pipefail
export LC_ALL=C

usage() {
  printf '%s\n' \
    'Usage: bash src/fedora-diagnostico.sh [--section base|graphics|resources|security|all]' \
    'Default: base. Each additional section includes base context.' \
    'Read-only; prints to stdout. Does not collect logs or query personal identifiers.' \
    'Exit 0: queries completed; 1: partial report; 2: invalid arguments.'
}
section=base
if [[ $# -gt 0 ]]; then
  case "$1" in
    --help|-h) [[ $# -eq 1 ]] || { usage >&2; exit 2; }; usage; exit 0 ;;
    --section) [[ $# -eq 2 ]] || { usage >&2; exit 2; }; section=$2 ;;
    *) usage >&2; exit 2 ;;
  esac
fi
case "$section" in base|graphics|resources|security|all) ;; *) usage >&2; exit 2 ;; esac
partial=0

# Tools are optional. Do not turn bus/permission errors into healthy states.
query() {
  local label=$1 output rc
  shift
  printf '\n-- %s --\n' "$label"
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'Unavailable: %s\n' "$1"
    partial=1
    return
  fi
  if ! command -v timeout >/dev/null 2>&1; then
    printf '%s\n' 'Unavailable: timeout; query skipped to avoid blocking.'
    partial=1
    return
  fi
  if output=$(timeout --kill-after=2s 10s "$@" 2>/dev/null); then
    printf '%s\n' "${output:-No output.}"
  else
    rc=$?
    printf '%s\n' "${output:-No verifiable result.}"
    printf 'Query exited with status %s; review before interpreting the state.\n' "$rc"
    partial=1
  fi
}

printf '%s\n' '== Fedora-KDE: read-only local inspection =='
if [[ -r /etc/os-release ]]; then
  while IFS='=' read -r field value; do
    case "$field" in
      ID|VERSION_ID|VARIANT_ID|PRETTY_NAME) printf '%s: %s\n' "$field" "$value" ;;
    esac
  done < /etc/os-release
else
  printf '%s\n' 'System: unavailable'
  partial=1
fi
query 'Kernel' uname -r
query 'Architecture' uname -m
printf '\nReported session: %s\n' "${XDG_SESSION_TYPE:-unavailable}"
printf 'Reported desktop: %s\n' "${XDG_CURRENT_DESKTOP:-unavailable}"
if [[ -n ${SSH_CONNECTION:-} || -n ${SSH_TTY:-} ]]; then
  printf '%s\n' 'SSH access detected; the queried session may not be the graphical session.'
fi
if [[ -e /run/.containerenv || -e /.dockerenv ]]; then
  printf '%s\n' 'Container detected; these data do not fully describe the host.'
fi
if [[ -e /run/ostree-booted ]]; then
  printf '%s\n' 'OSTree host detected; verify the deployment before administering packages.'
else
  printf '%s\n' 'No visible OSTree marker; confirm the edition and host access.'
fi
query 'Installed RPM versions (not proof of an active session)' rpm -q plasma-workspace kwin konsole

if [[ $section == graphics || $section == all ]]; then
  printf '\n%s\n' '== Graphics =='
  # Filter GPU and its driver only; do not print every PCI device.
  if command -v lspci >/dev/null 2>&1 && command -v awk >/dev/null 2>&1; then
    query 'GPU/driver (display classes only)' bash -o pipefail -c \
      'lspci -nnk | awk '\''/^[^[:space:]]/ {show=($0 ~ /VGA compatible controller|3D controller|Display controller/)} show {print}'\'''
  else
    printf '%s\n' 'GPU: unavailable (lspci/awk); no tools are installed.'
    partial=1
  fi
  printf '%s\n' 'For modes/scaling, query kscreen-doctor -o only in the affected graphical session.'
fi
if [[ $section == resources || $section == all ]]; then
  printf '\n%s\n' '== Resources =='
  query 'Memory' free -h
  query 'Swap: type/size/usage, without paths' swapon --show --output TYPE,SIZE,USED,PRIO
  query 'Root space, without device identifiers' df -h --output=size,used,avail,pcent /
  query 'Root filesystem' findmnt -n -o FSTYPE /
  query 'Boot time' systemd-analyze time
fi
if [[ $section == security || $section == all ]]; then
  printf '\n%s\n' '== Protection =='
  query 'SELinux' getenforce
  query 'Local firewalld status' systemctl show firewalld.service --property=LoadState,ActiveState,SubState,UnitFileState --no-pager
fi
printf '\n%s\n' \
  'This report is not universally anonymized: queried versions and models remain technical information.' \
  'Do not save this report in the plugin or share it without review. Missing data do not prove absence of faults.'
exit "$partial"
