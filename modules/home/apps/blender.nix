{ pkgs, ... }:
{
  home.packages = with pkgs; [
    blender
    cudaPackages.cudatoolkit
  ];
}
