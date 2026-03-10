{ pkgs, inputs, ... }:
{
  #home.packages = with pkgs; [
  #  librewolf
  #];
  home.packages = [ inputs.librewolf.legacyPackages.${pkgs.system}.librewolf ];
}
