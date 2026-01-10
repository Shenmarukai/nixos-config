{ inputs, pkgs, lib, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in {
  home.packages = [
    inputs.opencode.packages.${system}.default
  ];

  xdg.configFile."opencode/opencode.jsonc".source =
    ../../../home/shane/opencode/opencode.jsonc;

  xdg.configFile."opencode/AGENTS.md".source =
    ../../../home/shane/opencode/AGENTS.md;

  xdg.configFile."opencode/opencode-general-harness.jsonc".source =
    ../../../home/shane/opencode/opencode-general-harness.jsonc;


}
