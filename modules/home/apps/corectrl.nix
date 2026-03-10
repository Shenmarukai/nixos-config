{ pkgs, ... }:
{
  home.packages = with pkgs; [
    corectrl
  ];
}
