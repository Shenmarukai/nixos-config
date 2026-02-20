{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.liquidctl ];
}
