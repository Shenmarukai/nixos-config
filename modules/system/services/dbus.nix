{ pkgs, ... }:
{
  services.dbus.packages = with pkgs; [
    dconf
    corectrl
  ];

  services.dbus.enable = true;
}
