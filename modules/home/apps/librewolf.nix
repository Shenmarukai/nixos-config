{ pkgs, inputs, ... }:
{
  #home.packages = [ pkgs.librewolf ];
  home.packages = [ inputs.librewolf.legacyPackages.${pkgs.system}.librewolf ];
}
