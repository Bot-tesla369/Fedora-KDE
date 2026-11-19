#!/usr/bin/env bash
# Consultas locales sin sudo, red, instalaciones ni archivos de salida.
set -uo pipefail
export LC_ALL=C

usage() {
  printf '%s\n' \
    'Uso: bash src/fedora-diagnostico.sh [--section base|graphics|resources|security|all]' \
    'Sin opciones: base. Cada sección adicional incluye el contexto base.' \
    'Solo lectura; imprime en stdout. No recopila logs ni busca identificadores personales.' \
    'Salida 0: consultas realizadas; 1: informe parcial; 2: argumentos incorrectos.'
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

# Las herramientas son opcionales. No convertir errores de bus/permisos en estados sanos.
query() {
  local label=$1 output rc
  shift
  printf '\n-- %s --\n' "$label"
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'No disponible: %s\n' "$1"
    partial=1
    return
  fi
  if ! command -v timeout >/dev/null 2>&1; then
    printf '%s\n' 'No disponible: timeout; consulta omitida para evitar bloqueos.'
    partial=1
    return
  fi
  if output=$(timeout --kill-after=2s 10s "$@" 2>/dev/null); then
    printf '%s\n' "${output:-Sin salida.}"
  else
    rc=$?
    printf '%s\n' "${output:-Sin resultado verificable.}"
    printf 'Consulta con salida %s; revisar antes de interpretar el estado.\n' "$rc"
    partial=1
  fi
}

printf '%s\n' '== Fedora-KDE: inspección local de solo lectura =='
if [[ -r /etc/os-release ]]; then
  while IFS='=' read -r field value; do
    case "$field" in
      ID|VERSION_ID|VARIANT_ID|PRETTY_NAME) printf '%s: %s\n' "$field" "$value" ;;
    esac
  done < /etc/os-release
else
  printf '%s\n' 'Sistema: no disponible'
  partial=1
fi
query 'Kernel' uname -r
query 'Arquitectura' uname -m
printf '\nSesión declarada: %s\n' "${XDG_SESSION_TYPE:-no disponible}"
printf 'Escritorio declarado: %s\n' "${XDG_CURRENT_DESKTOP:-no disponible}"
if [[ -n ${SSH_CONNECTION:-} || -n ${SSH_TTY:-} ]]; then
  printf '%s\n' 'Acceso SSH detectado; la sesión consultada puede no ser la sesión gráfica.'
fi
if [[ -e /run/.containerenv || -e /.dockerenv ]]; then
  printf '%s\n' 'Contenedor detectado; estos datos no describen por completo el host.'
fi
if [[ -e /run/ostree-booted ]]; then
  printf '%s\n' 'Host OSTree detectado; verificar despliegue antes de administrar paquetes.'
else
  printf '%s\n' 'Sin marcador OSTree visible; confirmar edición y acceso al host.'
fi
query 'Versiones RPM instaladas (no prueba de sesión activa)' rpm -q plasma-workspace kwin konsole

if [[ $section == graphics || $section == all ]]; then
  printf '\n%s\n' '== Gráficos =='
  # Filtra solo GPU y su controlador; no imprime todos los dispositivos PCI.
  if command -v lspci >/dev/null 2>&1 && command -v awk >/dev/null 2>&1; then
    query 'GPU/controlador (solo clases de pantalla)' bash -o pipefail -c \
      'lspci -nnk | awk '\''/^[^[:space:]]/ {show=($0 ~ /VGA compatible controller|3D controller|Display controller/)} show {print}'\'''
  else
    printf '%s\n' 'GPU: no disponible (lspci/awk); no se instala ninguna herramienta.'
    partial=1
  fi
  printf '%s\n' 'Para modos/escalado, consultar kscreen-doctor -o solo en la sesión gráfica afectada.'
fi
if [[ $section == resources || $section == all ]]; then
  printf '\n%s\n' '== Recursos =='
  query 'Memoria' free -h
  query 'Swap: tipo/tamaño/uso, sin rutas' swapon --show --output TYPE,SIZE,USED,PRIO
  query 'Espacio raíz, sin identificador de dispositivo' df -h --output=size,used,avail,pcent /
  query 'Sistema de archivos raíz' findmnt -n -o FSTYPE /
  query 'Tiempo de arranque' systemd-analyze time
fi
if [[ $section == security || $section == all ]]; then
  printf '\n%s\n' '== Protección =='
  query 'SELinux' getenforce
  query 'Estado local de firewalld' systemctl show firewalld.service --property=LoadState,ActiveState,SubState,UnitFileState --no-pager
fi
printf '\n%s\n' \
  'Informe sin anonimización universal: las versiones y modelos consultados siguen siendo datos técnicos.' \
  'No guardarlo en el plugin ni compartirlo sin revisarlo. Datos ausentes no prueban ausencia de fallos.'
exit "$partial"
