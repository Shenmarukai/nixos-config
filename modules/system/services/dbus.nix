{ pkgs, ... }:
{
  services.dbus.packages = [
    pkgs.dconf
    pkgs.corectrl
  ];

  services.dbus.enable = true;
}
