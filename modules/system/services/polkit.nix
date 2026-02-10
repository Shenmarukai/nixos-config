{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.polkit
    pkgs.kdePackages.polkit-kde-agent-1
    pkgs.kdePackages.polkit-qt-1
  ];

  security.polkit.enable = true;
}
