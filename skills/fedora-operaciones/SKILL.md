---
name: fedora-operaciones
description: "Administer Fedora: RPM or Flatpak installations, repositories, updates, firmware, and maintenance. Use for system operations after verifying traditional Fedora versus Kinoite/OSTree and the package manager actually available."
---

# Fedora operations

## Objective and inputs

Perform the requested installation or maintenance with a verifiable source, validation, and recovery appropriate to the change. Identify the package or application, objective, and user constraints.

## Procedure

1. Read the [shared protocol](../fedora-diagnostico/references/contexto-y-fuentes.md). Inspect the edition and host access. Distinguish traditional Fedora from Kinoite/OSTree and a Toolbx container; availability of `dnf` alone is insufficient evidence.
2. On traditional Fedora, check `dnf --version` and `dnf COMMAND --help` before choosing syntax; DNF4 and DNF5 can differ. On Kinoite, inspect `rpm-ostree status` and the official guide: prefer Flatpak for applications when appropriate and avoid installing on the host with DNF. Do not automate rebases, rollbacks, or deployment changes as generic maintenance.
3. Choose an appropriate distribution: Fedora repositories for native integration or Flatpak from a verifiable provider for isolation/distribution. Verify the actual name, architecture, source, installation scope, and required permissions. Do not add external repositories, keys, or broad permissions without explaining their necessity within the task. Distinguish user and system Flatpak installations.
4. Before a transaction, review the summary for package removals/replacements or repository changes. Do not default to `-y` if it hides that review. If dependency resolution exceeds the authorized objective, stop to explain the additional change. Metadata refreshes or remote searches can use network and cache; do not describe them as exclusively local reads.
5. Apply updates only as part of the request. `sudo dnf upgrade --refresh` applies to traditional Fedora and updates system packages; `flatpak update` can affect multiple applications. Limit the target when possible. Do not clear caches or run `autoremove` as a supposed speed improvement.
6. For firmware, `fwupdmgr get-updates`, if available, queries known updates; refreshing metadata can use the network. Before updating, verify the vendor, supported device, power supply, instructions, and restart requirements. Do not include firmware updates as routine tuning or promise rollback.
7. Verify package/source with `rpm -q PACKAGE` or `flatpak info ID` in the chosen scope, then test the requested function. Use the correct system/user context for services. If a restart is necessary, explain it and agree on timing before restarting. Document the recovery actually available; uninstalling a package does not automatically restore its data or configuration.

## Output and limitations

State what changed, why, its source, test result, and rollback or recovery limits. Do not switch editions or install a full desktop to solve a small setting issue. Successful installation does not prove compatibility. For a failure without an identified cause, continue with [fedora-diagnostico](../fedora-diagnostico/SKILL.md).
