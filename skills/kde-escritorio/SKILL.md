---
name: kde-escritorio
description: "Customize KDE Plasma on Fedora: panels, widgets, system tray, themes, colors, fonts, icons, cursors, wallpapers, decorations, shortcuts, and window behavior. Use for visual or usability changes; use kde-wayland-diagnostico for failures."
---

# Plasma customization

## Objective and inputs

Turn the requested appearance or function into concrete, readable, maintainable changes. A screenshot shows the visible result, not the version or installed extensions.

## Procedure

1. Read the [shared protocol](../fedora-diagnostico/references/contexto-y-fuentes.md). Identify the target component and check the Plasma version/session only when it affects the procedure. Do not assume Wayland or a device model.
2. Prefer System Settings, panel edit mode, and built-in widgets. Give interface paths matching the verified version; if they cannot be checked, explain that labels may vary. For a broad style change, first identify three to five high-impact adjustments.
3. Distinguish global themes, Plasma styles, window decorations, icons, colors, and Konsole schemes; they are not interchangeable. Check whether a global theme also changes the panel layout before applying it. Preserve the settings needed to restore affected components.
4. For an external plasmoid or theme, verify its source, maintenance, dependencies, and compatibility with the Plasma major version and session. KDE Store is a distribution channel, not a guarantee. Do not run remote installers or add extensions merely because they resemble a screenshot.
5. Apply changes in stages and verify contrast, scaling, readability, shortcuts, and the intended function. Avoid installing another compositor or switching sessions for appearance. For manual edits, verify the XDG path and KConfig key, back up only the affected file, and preserve permissions.
6. For terminals, continue with [kde-terminales](../kde-terminales/SKILL.md). If a setting does not apply or a widget fails, continue with [kde-wayland-diagnostico](../kde-wayland-diagnostico/SKILL.md), retaining what has already been verified.

## Output and limitations

Explain what to change, where, how to verify it, and how to undo it. Do not delete `~/.config`, replace whole files, or restart Plasma routinely. A theme preview does not prove compatibility or necessarily reflect the actual result.
