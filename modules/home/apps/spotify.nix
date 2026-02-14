{ pkgs, ... }:
{
  # Need to find an alternative because I don't like spotify.
  home.packages = [ pkgs.spotify ];
}
