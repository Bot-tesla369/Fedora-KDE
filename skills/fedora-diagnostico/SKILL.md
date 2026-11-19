---
name: fedora-diagnostico
description: "Diagnosticar y corregir errores de Fedora: inicio, servicios, red, audio, vídeo, suspensión, dispositivos, permisos y compatibilidad. Usar para fallos del sistema; para paneles, ventanas y escalado, consultar kde-wayland-diagnostico del mismo plugin."
---

# Diagnóstico de Fedora

## Objetivo y entradas

Resolver el síntoma con evidencia y una corrección verificable. Recoge error exacto, momento del fallo, acción desencadenante y soluciones ya probadas; pide solo lo que no puedas consultar y que cambie la decisión.

## Procedimiento

1. Lee el [protocolo compartido](references/contexto-y-fuentes.md). Verifica acceso al host, edición, versión y sesión cuando sean relevantes. Si necesitas un resumen, ejecuta el script descrito allí con la sección correspondiente; no recolectes todas las secciones por rutina.
2. Elige dos o tres consultas que distingan hipótesis: estado del servicio afectado, paquete y versión, o registro limitado a la unidad y ventana del error. Consulta el journal del usuario para componentes de sesión. No interpretes ausencia de permisos como ausencia de errores.
3. Separa hardware/driver, red, permiso, aplicación, RPM/Flatpak, servicio y configuración. En audio, consulta `wpctl status` si existe y la salida/fuente seleccionada antes de reinstalar PipeWire. En red, comprueba estado y conectividad pertinentes sin solicitar perfiles, contraseñas ni un volcado de conexiones.
4. Si el problema es presentación de Plasma, sensores de un widget, ventanas o escalado, continúa con [kde-wayland-diagnostico](../kde-wayland-diagnostico/SKILL.md). Para paquetes o repositorios, usa [fedora-operaciones](../fedora-operaciones/SKILL.md). No abras otra auditoría completa al cambiar de skill.
5. Contrasta la compatibilidad según el protocolo. Para fallos tras actualizaciones, identifica qué cambió; no recomiendes bajar versiones, cambiar kernel o desactivar protecciones sin evidencia. Una prueba con otro kernel ya instalado debe permitir volver al estado inicial y no implica eliminar el actual.
6. Aplica la mínima corrección dentro del alcance autorizado, con respaldo si edita archivos. Reproduce la operación original y comprueba el resultado funcional; si persiste, usa el resultado para elegir la siguiente prueba en vez de acumular cambios.

## Salida y límites

Expón causa respaldada o hipótesis, evidencia, acción, validación y reversión cuando corresponda. Si no hay acceso, entrega comandos pendientes y explica qué resultado decidiría el siguiente paso. No prometas recuperar GRUB, EFI, discos o firmware mediante una receta genérica. No envíes registros o incidencias a terceros sin encargo explícito.
