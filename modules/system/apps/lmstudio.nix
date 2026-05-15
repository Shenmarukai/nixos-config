{ inputs, pkgs, ... }:
let
  lmstudio-pkgs = import inputs.lmstudio {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  environment.systemPackages = [
    lmstudio-pkgs.lmstudio
  ];
}
