{ config, pkgs, inputs, ... }: {
  imports = [
    ../hardware/shane-laptop-hardware.nix

    ./common/core/base.nix
    ./common/core/networking.nix

    ./common/optional/audio.nix
    ./common/optional/graphics.nix
    ./common/optional/gaming.nix
    ./common/optional/display-manager.nix

    ./common/users/shane.nix
  ];

  networking.hostName = "shane-laptop";

  system.stateVersion = "25.11";
}
