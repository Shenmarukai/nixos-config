{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  upstreamLauncher = inputs.hytale-launcher.packages.${system}.default;
  hytaleLauncherWrapped = pkgs.writeShellApplication {
    name = "hytale-launcher";
    text = ''
      export WEBKIT_DISABLE_DMABUF_RENDERER=1
      exec ${upstreamLauncher}/bin/hytale-launcher "$@"
    '';
  };
in
{
  home.packages = [
    hytaleLauncherWrapped
  ];

  xdg.desktopEntries.hytale-launcher = {
    name = "Hytale Launcher";
    genericName = "Hytale Launcher";
    comment = "Official launcher for Hytale";
    exec = "hytale-launcher";
    icon = "hytale-launcher";
    categories = [ "Game" ];
    terminal = false;
  };

}
