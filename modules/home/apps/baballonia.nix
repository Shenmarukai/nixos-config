{ pkgs, ... }:
{
  home.packages = [
    pkgs.baballonia
    pkgs.v4l-utils
    pkgs.psmisc
  ];

  xdg.desktopEntries.baballonia = {
    name = "Baballonia";
    genericName = "Baballonia";
    comment = "Utility application";
    exec = "baballonia";
    categories = [ "Utility" ];
    terminal = false;
  };
}
