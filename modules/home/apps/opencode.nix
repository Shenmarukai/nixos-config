{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in {
  home.packages = [ inputs.opencode.packages.${system}.default ];
}
