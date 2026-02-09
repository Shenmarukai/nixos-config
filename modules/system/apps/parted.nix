{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.parted
    pkgs.gparted
  ];
}
