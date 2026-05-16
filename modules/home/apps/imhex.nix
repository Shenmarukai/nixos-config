{ pkgs, inputs, ... }: {
  home.packages = [
    inputs.imhex.legacyPackages.${pkgs.stdenv.hostPlatform.system}.imhex
  ];
}
