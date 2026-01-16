# AGENTS.md

Repository: NixOS flake + Home Manager configs.
Scope: entire repo unless overridden by a deeper `AGENTS.md`.

This file is written for agentic coding tools. Keep changes small, follow the
existing Nix style, and validate changes with the cheapest command that proves
correctness.

---

## Cursor / Copilot rules

- Cursor rules: none found (`.cursor/`, `.cursorrules` not present).
- Copilot rules: none found (`.github/copilot-instructions.md` not present).

---

## Quick commands (most common)

### Enter dev environment
- `nix develop`
- `nix develop -c <command>` (run a command with dev deps available)

Dev shell includes: `git`, `home-manager`, `nixd`, `nixfmt-rfc-style`.

### Format (Nix)
- `nix fmt`
This repo defines `formatter = nixfmt-rfc-style` in the flake.

### Flake evaluation checks (CI-style “lint”)
- `nix flake check`
Runs flake/module evaluation checks.

### Build system closure only (no switch)
- `nix build .#nixosConfigurations.shane-desktop.config.system.build.toplevel`
- `nix build .#nixosConfigurations.shane-laptop.config.system.build.toplevel`

### Apply (system switch)
- `sudo nixos-rebuild switch --flake .#shane-desktop`
- `sudo nixos-rebuild switch --flake .#shane-laptop`

### Apply (system test; activates but doesn’t persist boot config)
- `sudo nixos-rebuild test --flake .#shane-desktop`
- `sudo nixos-rebuild test --flake .#shane-laptop`

### Apply (Home Manager)
- `home-manager switch --flake .#shane@shane-desktop`
- `home-manager switch --flake .#shane@shane-laptop`

Tip: prefer `test`/`nix build`/`home-manager switch` before `switch` where possible.

---

## “Single test” / “single target” guidance

This repo is primarily Nix code; there usually aren’t unit tests. The closest
analogs to “run one test” are “evaluate/build one target”.

### Fastest “does it evaluate?” checks
- `nix flake check` (broad but usually quick)
- If a change is host-specific, prefer building that host’s toplevel only:
  - `nix build .#nixosConfigurations.shane-desktop.config.system.build.toplevel`

### Build only a Home Manager activation package
Useful when changing `home/shane/**` modules without touching NixOS modules.
- `nix build .#homeConfigurations."shane@shane-desktop".activationPackage`
- `nix build .#homeConfigurations."shane@shane-laptop".activationPackage`

### When you need more visibility
- Add `-L` to show build logs: `nix build -L ...`
- For rebuilds: `sudo nixos-rebuild test --flake .#shane-desktop --show-trace`

### Discover available flake outputs
- `nix flake show`

(If this flake later adds `checks`, prefer
`nix build .#checks.x86_64-linux.<name>` to run exactly one check/test.)

---

## Repo layout (high level)

- `flake.nix`: inputs + output wiring
- `flake/outputs/*`: flake output definitions (nixos/home/packages/devshells/etc)
- `hosts/`: NixOS host entrypoints (`shane-desktop.nix`, `shane-laptop.nix`)
- `hardware/`: hardware-specific modules (kebab-case filenames)
- `modules/system/**`: NixOS modules
- `modules/home/**`: Home Manager modules
- `home/shane/**`: host-specific home configs + common/shared modules
- `pkgs/`: custom packages
- `overlays/`: nixpkgs overlays

Supported system: `x86_64-linux`.

---

## Code style (Nix)

### Formatting
- 2-space indentation.
- Use trailing semicolons in attrsets.
- Prefer compact attrsets when readable.
- Leave a blank line between logically distinct option blocks.

Run `nix fmt` before finalizing a patch.

### Imports (ordering and structure)
Keep imports ordered:
1. hardware (from `hardware/`)
2. modules/system (NixOS modules)
3. user/home overrides (Home Manager modules / `home/shane/**`)

Prefer importing modules via the appropriate host/home entrypoint rather than
wiring ad-hoc module imports everywhere.

### Naming conventions
- Filenames: kebab-case, descriptive (e.g. `shane-desktop-hardware.nix`).
- Options / local flags: lowerCamelCase.
- Prefer clear attrset keys; avoid one-letter names.

### `pkgs` usage
- Use `with pkgs;` only inside short package lists.
  - Good: `environment.systemPackages = with pkgs; [ git ripgrep ];`
  - Avoid: large files using `with pkgs;` globally; prefer `pkgs.<name>`.

### Prefer `inherit` over duplication
- Use `inherit foo bar;`
- Use `inherit (inputs) nixpkgs home-manager;` when passing flake inputs through.

### Conditionals and composition
Use Nix patterns, not shell logic:
- `lib.mkIf`, `lib.mkMerge`, `lib.mkDefault`, `lib.mkForce`
- Keep conditionals close to the options they control.
- Prefer explicit feature flags/options over inspecting the filesystem.

### Types and option definitions (when writing modules)
- Prefer declarative `options` with types (`lib.types.*`) when creating reusable modules.
- Use `lib.mkOption` with clear `description`.
- Keep defaults conservative; document surprising behavior.

### Error handling / assertions
Surface errors early and clearly:
- Prefer `assert ...;` for simple checks.
- Prefer `lib.asserts.assertMsg cond "message"` for user-facing messages.
- Avoid ad-hoc `builtins.trace` unless debugging locally (don’t commit traces).

### Secrets
- Do not commit secrets (tokens, keys, `.env` files).
- Reference secrets from outside the repo (external flake inputs, encrypted files, etc.).
- If you need a placeholder path, document it and fail clearly with an assertion.

---

## Adding new modules/packages

- New NixOS modules: `modules/system/<area>/<name>.nix`
- New Home Manager modules: `modules/home/<area>/<name>.nix`
- Wire modules in via the appropriate entrypoint (host/home), keep imports tidy.
- New packages: add under `pkgs/` and ensure `flake/outputs/packages.nix` picks it up.

Keep changes focused: avoid refactors unless required for the task.

---

## Git / change hygiene (agent guidance)

- Don’t run destructive git commands unless explicitly asked.
- Don’t commit/push unless explicitly requested.
- Keep diffs small and directly related to the requested change.

---

## Nested agent rules (important)

There is an additional `AGENTS.md` under:
- `home/shane/opencode/AGENTS.md`

When editing files inside `home/shane/opencode/**`, follow that file’s extra
workflow conventions (it overrides this file within its directory tree).

---
