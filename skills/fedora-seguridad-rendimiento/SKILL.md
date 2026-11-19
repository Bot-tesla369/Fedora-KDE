---
name: fedora-seguridad-rendimiento
description: "Evaluar y mejorar seguridad o rendimiento de Fedora KDE: CPU, RAM, swap/zRAM, almacenamiento, arranque, temperatura, batería, servicios, SELinux y firewalld. Usar para problemas medibles u optimización solicitada, sin recetas universales."
---

# Seguridad y rendimiento de Fedora KDE

## Objetivo y entradas

Mejorar una métrica o resolver una exposición concreta sin degradar funciones ni protecciones. Define carga de trabajo, síntoma y objetivo: latencia, memoria, arranque, temperatura, autonomía o regla de acceso.

## Procedimiento

1. Lee el [protocolo compartido](../fedora-diagnostico/references/contexto-y-fuentes.md). Obtén solo el contexto necesario y una línea base. El script permite `--section resources` o `--section security`; estas secciones no certifican el estado del sistema.
2. Elige métricas relacionadas con el síntoma: `free -h`, `swapon --show`, `zramctl` si existe, `df -h /`, `findmnt -n -o FSTYPE /`, `systemd-analyze time` o `systemd-analyze blame`. En el arranque distingue duración de una unidad de su contribución a la ruta crítica; un servicio lento no es necesariamente prescindible. Usa un monitor de procesos disponible sin volcar argumentos que puedan contener secretos.
3. Temperatura: consulta `sensors` solo si existe, identifica el sensor y la carga medida; no ejecutes `sensors-detect` como inspección inocua. Distingue temperatura de CPU, GPU y batería. No fijes un umbral universal sin documentación del hardware. Para un indicador en panel, continúa con [kde-wayland-diagnostico](../kde-wayland-diagnostico/SKILL.md).
4. Energía: comprueba batería/corriente y gestor de perfiles realmente activo antes de cambiarlo. No combines TLP, tuned u otros gestores sin verificar cómo interactúan en esa versión. Mantén comparables brillo, carga, perfil y alimentación al medir autonomía o temperatura.
5. Seguridad: consulta `getenforce` y el estado de firewalld cuando sean pertinentes. Investiga una denegación SELinux o regla concreta antes de intervenir; no desactives SELinux ni el firewall para mejorar rendimiento o probar por rutina. No abras puertos ni permisos fuera del objetivo. Evita generar políticas automáticamente a partir de todos los eventos.
6. Distingue caché de presión de memoria, swap de disco de zRAM y espacio aparente de uso real Btrfs. No hagas balance, borrado de snapshots, sysctl, cambios de scheduler, parámetros de kernel o desactivación de servicios como optimización general.
7. Relaciona evidencia y cuello de botella. Aplica un cambio reversible por vez, conserva el estado previo y repite la prueba en condiciones comparables. Si no mejora o rompe funciones, revierte y registra el resultado. Si no hay evidencia de un problema, dilo y evita modificar el equipo.

## Salida y límites

Entrega métrica inicial, causa o hipótesis, intervención concreta, comparación antes/después y reversión. No prometas mejoras porcentuales ni interpretes RAM libre, CPU libre o ausencia de logs como objetivo de optimización. Separa hallazgos de seguridad de mejoras de rendimiento.
