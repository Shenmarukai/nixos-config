{ pkgs, ... }:
{
  home.packages = [ pkgs.nodePackages_latest.typescript-language-server ];
}
