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
    hash = "sha256-ppK5TVMsmy/7uP1kc6hw3gHMxokD/hBZYt5IGHR3/ok=";
    #bunCpu = "x64";
    #bunOs = "linux";
  };
  opencodePackage = opencodePkgs.callPackage (opencodeSrc + "/nix/opencode.nix") {
    node_modules = opencodeNodeModules;
  };
  #opencodeNodeModules =
  #  (opencodePkgs.callPackage (opencodeSrc + "/nix/node_modules.nix") {
  #    rev = inputs.opencode.sourceInfo.shortRev or inputs.opencode.sourceInfo.rev or "unknown";
  #    hash = "sha256-0VwVhbOtK1r16cVSZcHaI/8fUPc6aYQiUnh7Q3bSHqs=";
  #    #bunCpu = "x64";
  #    #bunOs = "linux";
  #  }).overrideAttrs (old: {
  #    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.nodejs ];
  #    postFixup = (old.postFixup or "") + ''
  #      if [ -d "$out/node_modules/.bin" ]; then
  #        patchShebangs "$out/node_modules/.bin"
  #      fi

  #      find "$out" -path '*/node_modules/.bin/*' | while read -r f; do
  #        target="$(readlink -f "$f" || true)"
  #        if [ -n "$target" ] && [ -f "$target" ]; then
  #          patchShebangs "$target" || true
  #        fi
  #      done
  #    '';
  #  });
  #opencodePackage =
  #  (opencodePkgs.callPackage (opencodeSrc + "/nix/opencode.nix") {
  #    node_modules = opencodeNodeModules;
  #  }).overrideAttrs (old: {
  #    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ pkgs.nodejs pkgs.jq ];

  #    buildPhase = ''
  #      runHook preBuild
  #      cd ./packages/opencode

  #      echo "Rewriting app build script to bypass node_modules/.bin/vite..."
  #      tmp="$(mktemp)"
  #      ${pkgs.jq}/bin/jq \
  #        '.scripts.build = "${pkgs.nodejs}/bin/node ./node_modules/vite/bin/vite.js build"' \
  #        ../app/package.json > "$tmp"
  #      mv "$tmp" ../app/package.json

  #      bun --bun ./script/build.ts --single --skip-install
  #      bun --bun ./script/schema.ts schema.json
  #      runHook postBuild
  #    '';
  #  });
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
  ] ++ (with pkgs; [
    github-mcp-server
    python3
    units
    math-mcp
    mcp-proxy
  ]);

  xdg.configFile."opencode/opencode.jsonc" = {
    source = ../../../home/shane/opencode/opencode.jsonc;
  };

  #xdg.configFile."opencode" = {
  #  source = ../../../home/shane/opencode;
  #  recursive = true;
  #};
}
