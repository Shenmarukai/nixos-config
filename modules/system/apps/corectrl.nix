{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.corectrl
  ];
}
