{ pkgs, ... }:
{
  home.packages = [
    pkgs.kubectl
    pkgs.kubernetes-helm
    pkgs.kubectx
    pkgs.k9s
  ];
}
