{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    linuxPackages.cpupower
  ];
}
