---
name: kde-escritorio
description: "Personalizar KDE Plasma en Fedora: paneles, widgets, bandeja, temas, colores, fuentes, iconos, cursores, fondos, decoraciones, atajos y comportamiento de ventanas. Usar para cambios visuales o de uso; los fallos corresponden a kde-wayland-diagnostico."
---

# Personalización de Plasma

## Objetivo y entradas

Convertir la apariencia o función solicitada en cambios concretos, legibles y fáciles de mantener. Una captura muestra el resultado visible, no la versión ni los complementos instalados.

## Procedimiento

1. Lee el [protocolo compartido](../fedora-diagnostico/references/contexto-y-fuentes.md). Identifica el componente objetivo y comprueba versión de Plasma/sesión solo cuando afecten al procedimiento. No presupongas Wayland o un modelo de equipo.
2. Prioriza Preferencias del sistema, modo de edición del panel y widgets integrados. Da rutas de interfaz acordes con la versión comprobada; si no puedes verificarlas, indica que el nombre puede variar. Para un estilo amplio, concreta primero entre tres y cinco ajustes de mayor impacto.
3. Distingue tema global, estilo de Plasma, decoración de ventanas, iconos, colores y esquema de Konsole: no son intercambiables. Comprueba si un tema global altera también distribución de paneles antes de aplicarlo. Conserva los ajustes que permitan restaurar lo afectado.
4. Para un plasmoide o tema externo, verifica fuente, mantenimiento, dependencia y compatibilidad con la versión mayor de Plasma y sesión. KDE Store es un canal de distribución, no una garantía. No ejecutes instaladores remotos ni añadas complementos solo por parecerse a una captura.
5. Aplica un cambio por etapa y comprueba contraste, escalado, legibilidad, atajos y función deseada. Evita instalar otro compositor o cambiar de sesión para lograr una apariencia. Si requiere edición manual, verifica ruta XDG y clave KConfig, respalda solo el archivo afectado y conserva permisos.
6. Para terminales, continúa con [kde-terminales](../kde-terminales/SKILL.md). Si el ajuste no se aplica o el widget falla, continúa con [kde-wayland-diagnostico](../kde-wayland-diagnostico/SKILL.md) conservando lo ya comprobado.

## Salida y límites

Indica qué cambiar, dónde, cómo comprobarlo y cómo deshacerlo. No borres `~/.config`, reemplaces archivos completos ni reinicies Plasma por rutina. Una vista previa de tema no demuestra compatibilidad ni refleja necesariamente el resultado real.
