# NixOS + swayfx + NVIDIA + SteamVR

This repo tracks a NixOS 25.11 configuration built around:

- Nix flakes with explicit overlays, devshell, formatter, and home outputs
- swayfx (Wayland) via home-manager
- Proprietary NVIDIA drivers with open kernel modules (RTX 3090 now, RTX 5090-ready)
- greetd + tuigreet login flow
- Steam + SteamVR on Wayland

---

## Layout

- `flake.nix` – Entrypoint that wires inputs, overlays, NixOS + home-manager modules, host/home outputs, formatter, packages, and the development shell.
- `hardware/` – Auto-generated hardware configuration per host (e.g. `hardware/shane-desktop-hardware.nix`).
- `hosts/`
  - `common/core` – Machine settings that must exist on *all* hosts (bootloader, timezone, base packages, NetworkManager, etc.).
  - `common/optional` – Shared-but-optional host modules (audio, graphics, gaming, display manager, etc.).
  - `common/users` – Host-level user definitions plus hooks into per-user home configs.
  - `<hostname>.nix` – Host-specific entrypoints that pull in hardware, core modules, optional modules, and the needed users.
- `home/shane/`
  - `common/core` – User preferences that apply everywhere (shell programs, base packages, etc.).
  - `common/optional` – Optional user modules grouped by concern (dev tooling, sway, waybar, nixvim, etc.).
  - `hosts/<hostname>` – Home-manager fragments that only apply on specific machines (e.g. sway output layouts).
  - `<hostname>.nix` – Home-manager entrypoints that compose the common modules plus host-specific pieces.
- `modules/nixos`, `modules/home-manager` – Reserved for reusable modules (currently empty scaffolding, matching the “anatomy” structure).
- `pkgs/` – Placeholder for custom packages exposed through `packages.${system}`.
- `overlays/` – Placeholder for site-specific package overlays.
- `scripts/` – Ad-hoc helper scripts that haven’t been nixified yet.

## Commands

- Dev shell: `nix develop`
- Desktop host rebuild: `sudo nixos-rebuild switch --flake .#shane-desktop`
- Laptop host rebuild: `sudo nixos-rebuild switch --flake .#shane-laptop`
- CI-style build: `nix build .#nixosConfigurations.shane-desktop.config.system.build.toplevel`
- Home-only switch (desktop): `home-manager switch --flake .#shane@shane-desktop`
- Home-only switch (laptop): `home-manager switch --flake .#shane@shane-laptop`

Run GPU/display changes with `sudo nixos-rebuild switch` and reboot.

## Login Flow (greetd → swayfx)

1. `greetd` + `tuigreet` are configured in `hosts/common/optional/display-manager.nix`.
2. `tuigreet` logs in as `shane` and starts sway (swayfx package).
3. sway loads the home-manager config from `home/shane/common/optional/wm-sway.nix`; Xwayland is available for legacy apps/Steam.

## Desktop Basics

### swayfx

Configured in `home/shane/common/optional/wm-sway.nix`. Highlights:

- `package = pkgs.swayfx;`
- Terminal: `ghostty`
- Startup commands: `waybar`, `mako`
- Extra env for NVIDIA:

  ```nix
  extraSessionCommands = ''
    export WLR_NO_HARDWARE_CURSORS=1
  '';
  ```

### Keybindings & Usage

`Mod` refers to the Super/Windows key. Default bindings are defined in `home/shane/common/optional/wm-sway.nix`:

| Shortcut | Action |
| --- | --- |
| `Mod+Return` | Launch `ghostty` |
| `Mod+D` | Open rofi (`rofi -show drun`) |
| `Mod+Shift+Q` | Close focused window |
| `Mod+Shift+C` | Reload sway config |

Startup commands (`waybar`, `mako`) are declared under `config.startup`, so they launch automatically. Add more keybindings or startup entries in `home/shane/common/optional/wm-sway.nix` as needed.

### Launchers & Apps

- **Rofi (Wayland build)** – Installed via `home/shane/common/core/packages.nix`; launch with `Mod+D` and use `drun` entries.
- **Discord** – Also provided by `home/shane/common/core/packages.nix`. Launch via rofi or `ghostty` (`discord`).

### Waybar & Mako

Managed via home-manager:

- `programs.waybar` – Configured in `home/shane/common/optional/ui-waybar.nix`. Simple bar with workspaces / clock / VRR indicator / audio / battery / tray.
- `services.mako.enable = true;` – Defined in `home/shane/common/core/programs.nix`.

## NVIDIA + Wayland

Defined in `hosts/common/optional/graphics.nix`:

```nix
nixpkgs.config.allowUnfree = true;
services.xserver.videoDrivers = [ "nvidia" ];

hardware.graphics = {
  enable = true;
  enable32Bit = true;
};

hardware.nvidia = {
  modesetting.enable = true;
  open = true;
  nvidiaSettings = true;
  powerManagement.enable = true;
  powerManagement.finegrained = false;
};

boot.kernelParams = [ "nvidia_drm.modeset=1" ];
```

This uses NVIDIA’s proprietary userspace with open kernel modules, working well on Wayland/GBM for both RTX 3090 and future RTX 5090 cards.

## Steam + SteamVR

Enabled in `hosts/common/optional/gaming.nix`:

```nix
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
};

hardware.steam-hardware.enable = true;
```

Usage:

1. Log into swayfx.
2. Launch `steam` from Ghostty (or add a launcher binding).
3. Install games and SteamVR normally.

If a specific title or headset needs a newer driver, update the `nixpkgs` input or temporarily pin a newer driver in `hosts/common/optional/graphics.nix` (`hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;`).

## Upgrading to RTX 5090

When the new GPU arrives:

1. Update the `nixpkgs` input in `flake.nix` to a revision that supports the 5090.
2. Rebuild: `sudo nixos-rebuild switch --flake .#shane-desktop` (reboot afterward).
3. If necessary, temporarily pin a newer driver as mentioned above.
4. Keep `hardware.nvidia.open = true` and `nvidia_drm.modeset=1`; they apply to both GPUs.

## Troubleshooting

- sway fails to start? Recheck `nvidia_drm.modeset=1`, `hardware.nvidia.open = true`, and the greetd command in `hosts/common/optional/display-manager.nix`.
- Cursor glitches? Leave `WLR_NO_HARDWARE_CURSORS=1` enabled, or only remove it after confirming stability.
- Audio issues? Confirm PipeWire is running (`systemctl --user status pipewire.service`).
- Always rebuild (`nixos-rebuild` + `home-manager switch`) and reboot after GPU/driver tweaks.
