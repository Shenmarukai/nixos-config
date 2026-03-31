# NixOS + Home Manager for two hosts

This repo is a Nix flake for a 2-host NixOS setup with Home Manager for user config.

Hosts:
- `shane-desktop`
- `shane-laptop`

## What it provides

- `swayfx` + `greetd` login flow
- host/module-specific NVIDIA Wayland support
- Steam
- PipeWire + WirePlumber audio
- dev tooling and language servers
- `opencode`
- `nvim`
- browser configs/packages

## Layout

- `hosts/` — host-specific NixOS entrypoints
- `hardware/` — hardware configs for each host
- `home/shane/` — shared Home Manager modules, per-host entrypoints, and host-specific output wiring for `shane`
- `modules/system/` — reusable NixOS modules
- `modules/home/` — reusable Home Manager modules
- `flake/outputs/` — flake output wiring
- `pkgs/` — custom packages
- `overlays/` — package overlays
- `devenv/` — development shell/environment setup and the repo's development/agent harness

## Usage

Rebuild a host:

```bash
sudo nixos-rebuild switch --flake .#shane-desktop
sudo nixos-rebuild switch --flake .#shane-laptop
```

Enter the dev shell:

```bash
nix develop
```

Home Manager rebuilds can also be run per host:

```bash
home-manager switch --flake .#shane@shane-desktop
home-manager switch --flake .#shane@shane-laptop
```

## Notes

- The flake is organized around host-specific system configs plus shared system/home modules.
- It also exports `packages`, `formatter`, and `devShells`.
- `swayfx` is the default Wayland desktop path, launched through `greetd`.
- NVIDIA, Steam, audio, and developer tooling are configured through the module tree above.
