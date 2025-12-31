{ config, pkgs, inputs, ... }: {
  imports = [
    ../hardware/shane-desktop-hardware.nix

    ./common/core/base.nix
    ./common/core/networking.nix

    ./common/optional/audio.nix
    ./common/optional/graphics.nix
    ./common/optional/gaming.nix
    ./common/optional/display-manager.nix

    ./common/users/shane.nix
  ];

  networking.hostName = "shane-desktop";

  system.stateVersion = "25.11";
}
