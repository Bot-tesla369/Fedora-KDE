---
name: kde-wayland-diagnostico
description: "Diagnose Plasma, KWin, and Wayland/X11 session failures on Fedora: panels, tray, plasmoids, sensors, themes, windows, effects, scaling, and monitors. Use for broken desktop functions or settings that do not apply."
---

# Desktop and graphics diagnostics

## Objective and inputs

Restore the affected function without routinely restarting or resetting the entire desktop. Identify the symptom, session, component, recent changes, and expected result.

## Procedure

1. Read the [shared protocol](../fedora-diagnostico/references/contexto-y-fuentes.md). Confirm the Plasma version, actual session, and access to the affected desktop. The script's `--section graphics` provides GPU/driver and installed versions; it does not establish display modes or acceleration. Use `kscreen-doctor -o` if available, only in the affected session when those details are needed.
2. Distinguish four cases: a missing component, a present component with no data, incorrect data, and rendering errors. First check visible settings/permissions, then the data source, compatibility, and extension conflicts. Collect limited user logs when they distinguish hypotheses. If a driver/kernel issue is suspected, investigate it alongside the graphics layer without assuming a visual theme problem.
3. For sensors, distinguish `lm_sensors`/`sensors`, the Plasma sensor provider, and the consuming widget. Installing `lm_sensors` neither creates widgets nor guarantees that Plasma receives all temperatures. Identify the required sensor and whether it belongs in a panel, tray, or system monitor.
4. For missing panels/widgets, check the affected panel/display, edit mode, widget list, tray, and plasmoid package. Test a built-in component or disable only the suspected extension with a restoration path. Do not remove global Plasma configuration or the entire widget set.
5. For scaling/multiple monitors, compare modes, refresh rates, scales, and connectors against display and driver support. Distinguish native Wayland applications from XWayland when relevant. Start with reversible visual settings; do not delete KScreen configuration or force global parameters. For decorations/effects, check KWin support and the extension version.
6. For failures after updating, identify the package and review documentation/issues for that version. Switching to X11 is not a universal fix; consider a temporary comparison only if that session already exists and state which hypothesis it tests. Do not install an alternative session or kill KWin for routine testing.
7. If the cause concerns permissions, kernel, drivers, packages, or base services, continue with [fedora-diagnostico](../fedora-diagnostico/SKILL.md) or [fedora-operaciones](../fedora-operaciones/SKILL.md). Apply one correction and verify the exact behavior; revert if it worsens and avoid speculative chains of changes.

## Output and limitations

Provide the cause or hypothesis with evidence, a discriminating test, action, visual/functional validation, and rollback. Do not invent unit names, KConfig keys, flags, or packages. Terminating KWin may close a Wayland session; do not treat its restart as harmless.
