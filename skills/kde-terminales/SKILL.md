---
name: kde-terminales
description: "Configurar Konsole y terminales en Fedora KDE: perfiles, colores, fuentes, prompt, inicio interactivo, Fastfetch, arte ASCII e imágenes. Usar para apariencia y comportamiento de terminal; no para monitorización persistente en panel."
---

# Konsole y shell interactivo

## Objetivo y entradas

Conseguir una terminal útil y consistente, con inicio rápido y sin dependencias innecesarias. Identifica terminal, shell que se está ejecutando y función deseada.

## Procedimiento

1. Lee el [protocolo compartido](../fedora-diagnostico/references/contexto-y-fuentes.md). Comprueba la terminal real y su versión. `$SHELL` indica el shell configurado para el usuario, no siempre el proceso actual: confirma con el contexto o una consulta dirigida al proceso cuando importe. No vuelques el entorno completo ni historial.
2. Empieza por Configuración → Editar perfil en Konsole, comprobando nombres de menú según versión. Distingue esquema de colores, fuente, cursor, pestañas y transparencia; esta última depende también del compositor. Un perfil no equivale a la configuración de Bash/Zsh/Fish.
3. Para prompt o inicio, verifica shell, modo interactivo y archivo que realmente carga. Respeta XDG y la configuración existente. No edites indistintamente `.bashrc`, `.zshrc` o `config.fish`. No instales Starship, Oh My Zsh o Nerd Fonts salvo que una función elegida lo necesite.
4. Para Fastfetch, comprueba `command -v fastfetch` y la ayuda de la versión instalada. Añade una sola llamada identificable en el inicio interactivo apropiado, condicionada a que exista el programa y haya terminal. Omite automatizaciones, sesiones no interactivas y SSH salvo que el usuario quiera ese comportamiento; usa sintaxis del shell real. Configura solo la información que el usuario quiere mostrar.
5. Para imágenes, diferencia texto/ASCII de SIXEL, Kitty e iTerm2. Comprueba el protocolo soportado por esa versión de terminal y si tmux/SSH intervienen. Haz una prueba acotada con un archivo elegido; no garantices soporte por usar KDE o Wayland. Prioriza ASCII si cubre el objetivo.
6. Antes de editar, guarda copia fuera del plugin. Evita bloques duplicados y permisos de root en archivos del usuario. Comprueba sintaxis con la herramienta del shell correspondiente sin ejecutar el archivo como prueba. Abre una sesión nueva y verifica salida, tiempo de apertura y ausencia de errores; conserva una sesión funcional para revertir.

## Salida y límites

Entrega los archivos/perfiles afectados, resultado y reversión exacta del bloque añadido o perfil. No uses scripts descargados como instaladores de apariencia. Para datos permanentes en el panel, usa [kde-escritorio](../kde-escritorio/SKILL.md); un encabezado de Konsole no es un monitor continuo.
