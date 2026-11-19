---
name: fedora-operaciones
description: "Administrar Fedora: instalaciones RPM o Flatpak, repositorios, actualizaciones, firmware y mantenimiento. Usar para operaciones del sistema verificando primero Fedora tradicional frente a Kinoite/OSTree y el gestor realmente disponible."
---

# Operaciones de Fedora

## Objetivo y entradas

Realizar la instalación o mantenimiento solicitado con origen comprobable, verificación y recuperación proporcionada al cambio. Identifica paquete o aplicación, objetivo y restricciones del usuario.

## Procedimiento

1. Lee el [protocolo compartido](../fedora-diagnostico/references/contexto-y-fuentes.md). Consulta edición y acceso al host. Distingue Fedora tradicional de Kinoite/OSTree y un contenedor Toolbx; no uses la disponibilidad de `dnf` como única prueba.
2. En Fedora tradicional, confirma `dnf --version` y `dnf COMANDO --help` antes de elegir sintaxis; DNF4 y DNF5 pueden diferir. En Kinoite, comprueba `rpm-ostree status` y la guía oficial: favorece Flatpak para aplicaciones cuando corresponda y evita instalar en el host con DNF. No automatices rebase, rollback o cambios de despliegue como mantenimiento genérico.
3. Elige la distribución apropiada: repositorios Fedora para integración nativa o Flatpak del proveedor verificable para aislamiento/distribución. Comprueba nombre real, arquitectura, origen, ámbito de instalación y permisos requeridos. No añadas repositorios externos, claves o permisos amplios sin justificar su necesidad dentro de la tarea. Para Flatpak, distingue instalación de usuario y del sistema.
4. Antes de una transacción, revisa el resumen y si elimina/reemplaza paquetes o cambia repositorios. No uses `-y` por defecto si oculta esa revisión. Si la resolución sale del objetivo autorizado, detente para explicar el cambio adicional. Una actualización de metadatos o búsqueda remota puede usar red y caché: no la describas como lectura exclusivamente local.
5. Aplica actualizaciones solo como parte de la petición. `sudo dnf upgrade --refresh` corresponde a Fedora tradicional y actualiza paquetes del sistema; `flatpak update` puede afectar varias aplicaciones. Acota el objetivo cuando sea posible. No limpies cachés ni ejecutes `autoremove` como supuesto acelerador.
6. Firmware: si existe, `fwupdmgr get-updates` consulta actualizaciones conocidas; refrescar metadatos puede usar red. Antes de actualizar, verifica proveedor, dispositivo compatible, alimentación, instrucciones y necesidad de reinicio. No lo incluyas como optimización rutinaria ni prometas reversión.
7. Verifica paquete/origen con `rpm -q PAQUETE` o `flatpak info ID` en el ámbito elegido, y prueba la función solicitada. Para servicios utiliza el contexto sistema/usuario correcto. Si hace falta reiniciar, informa y acuerda el momento antes de hacerlo. Documenta la recuperación realmente disponible; desinstalar un paquete no restaura automáticamente sus datos o configuración.

## Salida y límites

Indica qué cambió, por qué, procedencia, resultado de la prueba y reversión o límite de recuperación. No cambies a otra edición ni instales un escritorio completo para resolver un ajuste puntual. No prometas una versión compatible solo porque el paquete se instaló. Ante un fallo sin causa, continúa con [fedora-diagnostico](../fedora-diagnostico/SKILL.md).
