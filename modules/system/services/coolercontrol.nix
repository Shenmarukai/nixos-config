{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    coolercontrol.coolercontrold
  ];
}
