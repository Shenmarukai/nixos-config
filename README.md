# NixOS + swayfx + NVIDIA + SteamVR

This repo tracks a NixOS 25.11 configuration built around:

- Nix flakes
- swayfx (Wayland) via home-manager
- Proprietary NVIDIA driver with open kernel modules (RTX 3090 now, RTX 5090-ready)
- greetd + tuigreet login
- Steam + SteamVR on Wayland

---

## Layout

- `flake.nix` – Entrypoint for NixOS + home-manager.
- `configuration.nix` – System configuration (boot, NVIDIA, greetd, Steam, etc.).
- `hardware-configuration.nix` – Auto-generated hardware config.
- `home.nix` – Home-manager config for user `shane` (swayfx, waybar, mako, ghostty, rofi, Discord, etc.).

## Prerequisites

- NixOS 25.11 (or compatible) installed with flakes enabled (already set in `configuration.nix`).
- Repository cloned locally, e.g. `~/nixos-config`.

## Build + Apply

```bash
sudo nixos-rebuild switch --flake .#nixos
home-manager switch --flake .#shane
```

Reboot after GPU/display changes.

## Login Flow (greetd → swayfx)

1. `greetd` starts `tuigreet` on boot.
2. `tuigreet` logs in as `shane` and runs `sway` (swayfx package).
3. sway launches with the home-manager config; Xwayland is available for legacy apps/Steam, but no standalone X11 session is used.

## Desktop Basics

### swayfx

Configured in `home.nix` (`wayland.windowManager.sway`). Highlights:

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

`Mod` refers to the Super/Windows key. Default bindings defined in `home.nix`:

| Shortcut | Action |
| --- | --- |
| `Mod+Return` | Launch `ghostty` terminal |
| `Mod+D` | Open rofi (`rofi -show drun`) |
| `Mod+Shift+Q` | Close focused window |
| `Mod+Shift+C` | Reload sway config |

Startup commands (`waybar`, `mako`) are declared under `config.startup`, so they launch automatically. Add more keybindings or startup entries in `home.nix` as needed (e.g. other launchers, screenshots, audio controls).

### Launchers & Apps

- **Rofi (Wayland build)** – Installed via `home.packages`; open it with `Mod+D` and choose `drun` entries for any desktop app.
- **Discord** – Also installed in `home.packages`. Launch it through rofi (`Mod+D` → type "Discord") or via the terminal (`discord`).

### Waybar & Mako

Managed via home-manager:

- `programs.waybar` – simple bar with workspaces / clock / pulseaudio / battery / tray.
- `services.mako.enable = true;` – notifications.

## NVIDIA + Wayland

Set in `configuration.nix`:

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
  # When upgrading to an RTX 5090, update nixpkgs or temporarily set
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
};

boot.kernelParams = [ "nvidia_drm.modeset=1" ];
```

This uses NVIDIA's proprietary userspace with open kernel modules, which works well on Wayland/GBM for both RTX 3090 and future RTX 5090 cards.

## Steam + SteamVR

Enabled in `configuration.nix`:

```nix
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true;
};

hardware.steam-hardware.enable = true;
```

Usage:

1. Log into swayfx.
2. Launch `steam` from Ghostty (or add a launcher keybinding later).
3. Install games and SteamVR normally.

If a specific title or headset needs a newer driver, update the `nixpkgs` input or temporarily set `hardware.nvidia.package` as noted above.

## Upgrading to RTX 5090

When the new GPU arrives:

1. Update the `nixpkgs` input in `flake.nix` to a revision that supports the 5090.
2. Rebuild: `sudo nixos-rebuild switch --flake .#nixos` (reboot afterward).
3. If necessary, temporarily pin a newer driver:

   ```nix
   hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
   ```

4. Keep `open = true` and `nvidia_drm.modeset=1`; they apply to both GPUs.

## Troubleshooting

- sway fails to start? Recheck `nvidia_drm.modeset=1`, `hardware.nvidia.open = true`, and that greetd’s command is `... --cmd sway`.
- Cursor glitches? Leave `WLR_NO_HARDWARE_CURSORS=1` enabled, or only remove it once everything is stable.
- Audio issues? Confirm PipeWire is running (`systemctl --user status pipewire.service`).
- Always rebuild (`nixos-rebuild` + `home-manager switch`) and reboot after GPU/driver tweaks.
