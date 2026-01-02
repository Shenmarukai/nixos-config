{ config, pkgs, inputs, ... }: {
  imports = [
    ../hardware/shane-laptop-hardware.nix

    ../modules/system/core/nix-core.nix
    ../modules/system/core/boot-efi.nix
    ../modules/system/core/time-nyc.nix

    ../modules/system/network/networkmanager.nix

    ../modules/system/audio/pipewire-core.nix
    ../modules/system/audio/wireplumber-x2u.nix
    ../modules/system/audio/wireplumber-usb-speakers.nix

    ../modules/system/graphics/core.nix
    ../modules/system/graphics/nvidia.nix

    ../modules/system/packages/cli-tools.nix
    ../modules/system/packages/wayland-desktop.nix
    ../modules/system/apps/lmstudio.nix

    ../modules/system/services/gnome-keyring.nix
    ../modules/system/services/polkit.nix
    ../modules/system/services/greetd-tuigreet.nix

    ../modules/system/apps/steam-hardware.nix
    ../modules/system/apps/steam-remote-play.nix

    ../modules/system/users/shane.nix
  ];

  networking.hostName = "shane-laptop";

  system.stateVersion = "25.11";
}
