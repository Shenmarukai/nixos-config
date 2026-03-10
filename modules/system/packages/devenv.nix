{ inputs, pkgs, ... }:
{
  environment.systemPackages = [
    inputs.devenv.legacyPackages.${pkgs.system}.devenv
  ];
}
