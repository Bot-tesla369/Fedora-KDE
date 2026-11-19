---
name: fedora-diagnostico
description: "Diagnose and fix Fedora errors involving boot, services, networking, audio, video, suspend, devices, permissions, and compatibility. Use for system failures; for panels, windows, and scaling, consult kde-wayland-diagnostico in this plugin."
---

# Fedora diagnostics

## Objective and inputs

Resolve the symptom using evidence and a verifiable correction. Gather the exact error, failure time, triggering action, and attempted fixes. Ask only for information you cannot inspect and that changes the decision.

## Procedure

1. Read the [shared protocol](references/contexto-y-fuentes.md). Verify host access, edition, version, and session when relevant. If a summary is needed, run the script documented there with the appropriate section; do not collect every section routinely.
2. Choose two or three queries that distinguish hypotheses: affected service status, package and version, or a log limited to the relevant unit and error window. Use the user journal for session components. Do not interpret missing permissions as absence of errors.
3. Distinguish hardware/driver, networking, permissions, application, RPM/Flatpak, service, and configuration issues. For audio, inspect `wpctl status` if available and the selected output/source before reinstalling PipeWire. For networking, check relevant status and connectivity without requesting profiles, passwords, or a connection dump.
4. If the problem concerns Plasma presentation, widget sensors, windows, or scaling, continue with [kde-wayland-diagnostico](../kde-wayland-diagnostico/SKILL.md). For packages or repositories, use [fedora-operaciones](../fedora-operaciones/SKILL.md). Do not start another full audit when changing skills.
5. Verify compatibility using the protocol. For failures following updates, identify what changed; do not recommend downgrades, kernel changes, or disabling protections without evidence. Testing another already-installed kernel must allow returning to the initial state and does not imply removing the current kernel.
6. Apply the smallest correction within authorized scope, backing up files before edits. Reproduce the original operation and verify the functional result. If the failure persists, use that result to choose the next test instead of accumulating changes.

## Output and limitations

Report the supported cause or hypothesis, evidence, action, verification, and rollback when applicable. Without access, provide pending commands and explain which result determines the next step. Do not promise GRUB, EFI, disk, or firmware recovery through a generic recipe. Do not send logs or reports to third parties without an explicit request.
