{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vrr-status
  ];
}
