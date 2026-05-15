{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.vrcx.legacyPackages.${pkgs.stdenv.hostPlatform.system}.vrcx
  ];
}
