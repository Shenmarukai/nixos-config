{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.opencode-desktop.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode-desktop
  ];
}
