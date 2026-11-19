---
name: kde-terminales
description: "Configure Konsole and terminals on Fedora KDE: profiles, colors, fonts, prompts, interactive startup, Fastfetch, ASCII art, and images. Use for terminal appearance and behavior, not persistent panel monitoring."
---

# Konsole and interactive shells

## Objective and inputs

Create a useful, consistent terminal with fast startup and no unnecessary dependencies. Identify the terminal, running shell, and desired function.

## Procedure

1. Read the [shared protocol](../fedora-diagnostico/references/contexto-y-fuentes.md). Check the actual terminal and its version. `$SHELL` identifies the configured login shell, not always the current process; confirm through context or a targeted process query when relevant. Do not dump the entire environment or history.
2. Start with Settings → Edit Current Profile in Konsole, checking menu labels against the version. Distinguish the color scheme, font, cursor, tabs, and transparency; transparency also depends on the compositor. A profile is not equivalent to Bash/Zsh/Fish configuration.
3. For prompts or startup, verify the shell, interactive mode, and file actually loaded. Respect XDG and existing configuration. Do not edit `.bashrc`, `.zshrc`, and `config.fish` interchangeably. Do not install Starship, Oh My Zsh, or Nerd Fonts unless a chosen feature requires them.
4. For Fastfetch, check `command -v fastfetch` and help for the installed version. Add a single identifiable call in the appropriate interactive startup, conditional on the program and terminal being available. Skip automation, non-interactive sessions, and SSH unless the user wants that behavior; use the actual shell syntax. Display only the information the user wants.
5. For images, distinguish text/ASCII from SIXEL, Kitty, and iTerm2 protocols. Check what the terminal version supports and whether tmux/SSH is involved. Run a small test with a chosen file; KDE or Wayland alone does not guarantee support. Prefer ASCII if it meets the objective.
6. Before editing, save a backup outside the plugin. Avoid duplicate blocks and root permissions on user files. Check syntax with the appropriate shell tool without executing the file as a test. Open a new session and verify output, startup time, and absence of errors; keep a working session available for rollback.

## Output and limitations

Report affected files/profiles, result, and exact rollback for the added block or profile. Do not use downloaded scripts as appearance installers. For persistent panel data, use [kde-escritorio](../kde-escritorio/SKILL.md); a Konsole header is not a continuous monitor.
