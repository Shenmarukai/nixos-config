{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in {
  home.packages = [ inputs.opencode.packages.${system}.default ];

  xdg.configFile."opencode/opencode.jsonc".source =
    ../../../home/shane/opencode/opencode.jsonc;

  xdg.configFile."opencode/orchestration.md".source =
    ../../../home/shane/opencode/orchestration.md;
}
