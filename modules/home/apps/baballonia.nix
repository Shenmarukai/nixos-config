{ pkgs, ... }:
{
  home.packages = with pkgs; [
    baballonia
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
