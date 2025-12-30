# AGENTS
Repository: /home/shane/.config/nixos (NixOS flakes + home-manager).
No Cursor (.cursor/rules) or Copilot (.github/copilot-instructions.md) rules exist.
Build system + apply: `sudo nixos-rebuild switch --flake .#shane-desktop`.
Dry-run single host test: `sudo nixos-rebuild test --flake .#shane-desktop`.
Home profile: `home-manager switch --flake .#shane`.
CI-style build only: `nix build .#nixosConfigurations.shane-desktop.config.system.build.toplevel`.
Lint/check everything: `nix flake check` (runs evaluation + module checks).
Nix files use two-space indentation, trailing semicolons, and compact attrsets.
Keep module imports ordered: hardware → modules/system → user/home overrides.
Group related options, separating blocks with blank lines for readability.
Use `with pkgs;` only inside short package lists; otherwise reference `pkgs.<name>`.
Prefer `inherit`/`inherit (inputs)` to duplicate identifiers; keep new option names in lowerCamelCase.
Add new packages/modules under `modules/{system,home}` and import via host/home entrypoints.
When referencing files, use repo-relative paths and keep filenames kebab-case (e.g., `shane-desktop-hardware.nix`).
Handle conditionals with `lib.mkIf`, `mkMerge`, or explicit option flags instead of shell logic.
Surface errors via `assert` or `lib.asserts.assertMsg` rather than ad-hoc shell output.
Prefer declarative services/programs options; avoid mutable state or imperative scripts in modules.
Secrets stay outside the repo; reference them via external flakes or encrypted imports if needed.
Before opening PRs, run rebuild + flake check and ensure formatting matches existing style (no nixfmt defined).
