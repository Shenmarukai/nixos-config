{ inputs, pkgs, lib, ... }:
let
  lmstudio-pkgs = import inputs.lmstudio {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "lmstudio" ];
    };
  };
in {
  environment.systemPackages = [
    lmstudio-pkgs.lmstudio
  ];
}
