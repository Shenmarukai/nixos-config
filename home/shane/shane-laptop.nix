{ config, pkgs, inputs, ... }: {
  home.username = "shane";
  home.homeDirectory = "/home/shane";
  home.stateVersion = "25.11";

  imports = [
    ../../modules/home/packages.nix
    ../../modules/home/programs.nix
    ../../modules/home/sway.nix
    ../../modules/home/waybar.nix
  ];
}
