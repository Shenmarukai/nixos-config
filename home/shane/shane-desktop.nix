{ config, pkgs, inputs, ... }: {
  home.username = "shane";
  home.homeDirectory = "/home/shane";
  home.stateVersion = "25.11";

  imports = [
    inputs.nixvim.homeModules.nixvim

    ./common/core/programs.nix
    ./common/core/packages.nix

    ./common/optional/wm-sway.nix
    ./common/optional/ui-waybar.nix
    ./common/optional/editor-nixvim.nix
    ./common/optional/dev-tools.nix

    ./hosts/shane-desktop/outputs.nix
  ];
}
