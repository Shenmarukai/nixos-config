{ ... }:
let
  name = "nixos-module-placement";

  description =
    "repo-specific placement guidance for this nixos configuration repository. use when deciding whether a change belongs in a host file, hardware file, shared system module, shared home-manager module, host-specific home output, overlay, package definition, or flake output wiring.";

  body = ''
    Determine the best location for a change using this repository's structure.

    Repository structure:
    - `hosts/<host>.nix` = host-specific NixOS configuration.
    - `hardware/<host>-hardware.nix` = hardware-specific configuration.
    - `modules/system/...` = shared reusable NixOS modules.
    - `modules/home/...` = shared reusable Home Manager modules.
    - `home/shane/common/...` = shared user-level configuration.
    - `home/shane/hosts/<host>/outputs.nix` = host-specific Home Manager output wiring.
    - `overlays/` = nixpkgs/package overrides and package customization.
    - `pkgs/` = custom package definitions.
    - `flake/outputs/...` = flake output wiring and export composition.

    Placement rules:
    - Put one-off machine settings in `hosts/<host>.nix`.
    - Put hardware-specific settings in `hardware/<host>-hardware.nix`.
    - Put reusable system logic in `modules/system/...`.
    - Put reusable Home Manager logic in `modules/home/...`.
    - Put shared user configuration in `home/shane/common/...`.
    - Put host-specific user wiring in `home/shane/hosts/<host>/outputs.nix`.
    - Put package overrides in `overlays/`.
    - Put custom packages in `pkgs/`.
    - Put flake export composition in `flake/outputs/...`.

    Decision rules:
    - Prefer extending an existing module over creating a new top-level category.
    - Prefer small, single-purpose modules when a pattern is reusable.
    - Avoid putting reusable logic directly into host files.
    - Avoid putting package logic into service or host modules when it belongs in `pkgs/` or `overlays/`.
    - Avoid putting output wiring logic into feature modules.

    When analyzing a change, resolve:
    1. Is it system-level or user-level?
    2. Is it host-specific or shared?
    3. Is it package composition, service configuration, or flake wiring?
    4. Does an existing file already match this pattern?

    Return:
    1. Recommended location
    2. Why that location is best
    3. Alternatives rejected
    4. Concrete file or directory targets to inspect or edit
  '';
in {
  files.".claude/skills/${name}/SKILL.md".text = ''
    ---
    name: ${name}
    description: ${description}
    allowed-tools: Read, Glob, Grep, Bash
    model: sonnet
    effort: low
    context: fork
    agent: tansaku
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
