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
  opencodeNodeModules = opencodePkgs.callPackage (opencodeSrc + "/nix/node_modules.nix") {
    rev = inputs.opencode.sourceInfo.shortRev or inputs.opencode.sourceInfo.rev or "unknown";
    hash = "sha256-9oI1gekRbjY6L8VwlkLdPty/9rCxC20EJlESkazEX8Y=";
    bunCpu = "x64";
    bunOs = "linux";
  };
  opencodePackage = opencodePkgs.callPackage (opencodeSrc + "/nix/opencode.nix") {
    node_modules = opencodeNodeModules;
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

  xdg.configFile."opencode" = {
    source = ../../../home/shane/opencode;
    recursive = true;
  };
}
