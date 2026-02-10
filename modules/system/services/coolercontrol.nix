{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.coolercontrol.coolercontrold
  ];
}
