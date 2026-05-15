{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.opencode.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode
  ];

  xdg.configFile."opencode/opencode.jsonc" = {
    source = ../../../home/shane/opencode/opencode.jsonc;
  };
}
