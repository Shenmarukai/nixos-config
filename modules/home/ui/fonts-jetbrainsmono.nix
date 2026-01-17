{ pkgs, ... }:
{
  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];
  };

  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
