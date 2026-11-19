---
name: fedora-seguridad-rendimiento
description: "Assess and improve Fedora KDE security or performance: CPU, RAM, swap/zRAM, storage, boot, temperature, battery, services, SELinux, and firewalld. Use for measurable issues or requested optimization without universal tuning recipes."
---

# Fedora KDE security and performance

## Objective and inputs

Improve a metric or resolve a specific exposure without degrading functionality or protections. Define the workload, symptom, and objective: latency, memory, boot, temperature, battery life, or an access rule.

## Procedure

1. Read the [shared protocol](../fedora-diagnostico/references/contexto-y-fuentes.md). Gather only the necessary context and a baseline. The script supports `--section resources` and `--section security`; neither section certifies system health.
2. Choose symptom-related measurements: `free -h`, `swapon --show`, `zramctl` if available, `df -h /`, `findmnt -n -o FSTYPE /`, `systemd-analyze time`, or `systemd-analyze blame`. Distinguish a unit's duration from its contribution to the boot critical path; a slow service is not necessarily expendable. Use an available process monitor without dumping arguments that may contain secrets.
3. For temperature, query `sensors` only if available and identify the sensor and measured workload. Do not treat `sensors-detect` as harmless inspection. Distinguish CPU, GPU, and battery temperatures. Do not impose a universal threshold without hardware documentation. For a panel indicator, continue with [kde-wayland-diagnostico](../kde-wayland-diagnostico/SKILL.md).
4. For power, check battery/AC status and the active profile manager before changing it. Do not combine TLP, tuned, or other managers without checking their interaction in that version. Keep brightness, workload, profile, and power source comparable when measuring battery life or temperature.
5. For security, inspect `getenforce` and firewalld status when relevant. Investigate a specific SELinux denial or rule before acting; do not disable SELinux or the firewall for performance or routine testing. Do not open ports or permissions outside the objective. Avoid automatically generating policies from all events.
6. Distinguish cache from memory pressure, disk swap from zRAM, and apparent space from actual Btrfs usage. Do not balance filesystems, delete snapshots, tune sysctl or schedulers, change kernel parameters, or disable services as general optimization.
7. Connect the evidence to a bottleneck. Apply one reversible change at a time, preserve the previous state, and repeat the test under comparable conditions. If it does not help or breaks functionality, revert and record the result. If there is no evidence of a problem, say so and avoid modifying the machine.

## Output and limitations

Provide the baseline, cause or hypothesis, specific intervention, before/after comparison, and rollback. Do not promise percentage improvements or treat free RAM, idle CPU, or absence of logs as an optimization target. Separate security findings from performance improvements.
