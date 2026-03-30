{ ... }:
let
  name = "nixos-verify-workflow";

  description =
    "safe verification workflow for this personal nixos configuration repository. use when validating nix changes, checking evaluation or build behavior, determining the correct host target, distinguishing system versus home-manager verification, or deciding whether rebuild test or switch is appropriate.";

  body = ''
    Use this repository-aware verification workflow.

    Repository structure:
    - `hosts/<host>.nix` contains host-specific NixOS configuration.
    - `hardware/<host>-hardware.nix` contains hardware-specific configuration.
    - `modules/system/...` contains shared reusable NixOS modules.
    - `modules/home/...` contains shared reusable Home Manager modules.
    - `home/shane/hosts/<host>/outputs.nix` contains host-specific Home Manager output wiring.
    - `flake/outputs/nixos/` and `flake/outputs/home/` contain flake export wiring.
    - Known hosts include `shane-desktop` and `shane-laptop`.

    Verification ladder:
    1. Inspect and infer the affected scope first.
    2. Run evaluation-oriented checks when possible.
    3. Run `nix flake check`.
    4. Build the relevant target.
    5. For NixOS host changes, run `nixos-rebuild build --flake .#<host>`.
    6. Then run `nixos-rebuild dry-activate --flake .#<host>`.
    7. Use `nixos-rebuild test --flake .#<host>` only when live validation is needed.
    8. Use `nixos-rebuild switch --flake .#<host>` only when earlier checks pass and the caller is ready to apply.

    Scope rules:
    - Changes under `hosts/`, `hardware/`, or `modules/system/` usually imply system-level verification.
    - Changes under `modules/home/`, `home/shane/common/`, or `home/shane/hosts/` usually imply Home Manager or user-level verification.
    - Changes under `overlays/` or `pkgs/` may require both package-level and host-level verification depending on wiring.
    - Changes under `flake/outputs/` may affect target resolution and should be treated as wiring-sensitive.

    Host inference:
    - If files touched clearly point to `shane-desktop` or `shane-laptop`, use that host.
    - If the change is shared and the host is unclear, prefer build-oriented validation before any live activation.
    - Do not guess a host for `test` or `switch` if ambiguity remains.

    Rules:
    - Prefer the lowest-risk command that answers the question.
    - Distinguish evaluation failures, build failures, activation failures, and runtime behavior.
    - Call out whether the issue is host-specific, shared-module-specific, package-specific, or flake-wiring-specific.
    - Treat `switch` as the final apply step, not a routine default.
    - Report the exact next safest command.

    Output:
    1. Affected scope
    2. Likely host target if any
    3. Current verification stage
    4. Safest next command
    5. Apply recommendation
  '';
in {
  files.".claude/skills/${name}/SKILL.md".text = ''
    ---
    name: ${name}
    description: ${description}
    allowed-tools: Read, Glob, Grep, Bash
    disable-model-invocation: true
    model: sonnet
    effort: medium
    context: fork
    agent: tenken
    ---
    ${body}
  '';

  opencode.skills.${name} = ''
    ---
    name: ${name}
    description: ${description}
    ---
    ${body}
  '';
}
