{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.openrgb
  ];

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
    startupProfile = "catppuccin-blue.orp";
  };
}
