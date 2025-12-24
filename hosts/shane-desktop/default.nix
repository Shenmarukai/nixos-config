{ config, pkgs, inputs, ... }: {
  imports = [
    ../../hardware/shane-desktop-hardware.nix
    ../../modules/system/base.nix
    ../../modules/system/networking.nix
    ../../modules/system/audio.nix
    ../../modules/system/graphics.nix
    ../../modules/system/gaming.nix
    ../../modules/system/display-manager.nix
    ../../modules/system/users/shane.nix
  ];

  networking.hostName = "shane-desktop";

  system.stateVersion = "25.11";
}
