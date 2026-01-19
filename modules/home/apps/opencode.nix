{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  mcp-nixos = inputs.mcp-nixos.lib.mkMcpNixos {
    inherit pkgs;
    python3Packages = pkgs.python313Packages;
  };
  opencodePkgs = inputs.opencode.inputs.nixpkgs.legacyPackages.${system};
  opencodeSrc = inputs.opencode;
  opencodeNodeModules = opencodePkgs.callPackage (opencodeSrc + "/nix/node-modules.nix") {
    hash = "sha256-Fl1BdjNSg19LJVSgDMiBX8JuTaGlL2I5T+rqLfjSeO4=";
    bunCpu = "x64";
    bunOs = "linux";
  };
  opencodePackage = opencodePkgs.callPackage (opencodeSrc + "/nix/opencode.nix") { } {
    version = "1.1.23";
    src = opencodeSrc;
    mkNodeModules = opencodeNodeModules;
    scripts = opencodeSrc + "/nix/scripts";
    modelsDev = "${opencodePkgs.models-dev}/dist/_api.json";
  };
  github-mcp-server-gh = pkgs.writeShellScriptBin "github-mcp-server-gh" ''
    set -euo pipefail

    token="$(${pkgs.gh}/bin/gh auth token)"
    if [ -z "$token" ]; then
      echo "github-mcp-server-gh: gh auth token returned empty" >&2
      exit 1
    fi

    export GITHUB_PERSONAL_ACCESS_TOKEN="$token"
    exec ${pkgs.github-mcp-server}/bin/github-mcp-server stdio "$@"
  '';
in
{
  home.packages = [
    opencodePackage
    mcp-nixos
    github-mcp-server-gh
    pkgs.github-mcp-server
    pkgs.python3
    pkgs.units
    pkgs.math-mcp
    pkgs.mcp-proxy
  ];

  xdg.configFile."opencode/opencode.jsonc".source = ../../../home/shane/opencode/opencode.jsonc;

  xdg.configFile."opencode/agents" = {
    source = ../../../home/shane/opencode/agents;
    recursive = true;
  };

  xdg.configFile."opencode/prompts" = {
    source = ../../../home/shane/opencode/prompts;
    recursive = true;
  };

  xdg.configFile."opencode/commands" = {
    source = ../../../home/shane/opencode/commands;
    recursive = true;
  };

  xdg.configFile."opencode/tools" = {
    source = ../../../home/shane/opencode/tools;
    recursive = true;
  };

  xdg.configFile."opencode/skills" = {
    source = ../../../home/shane/opencode/skills;
    recursive = true;
  };
}
