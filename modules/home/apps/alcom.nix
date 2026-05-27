{ pkgs, ... }:

let
  alcom-fixed = pkgs.writeShellScriptBin "ALCOM" ''
    unset WAYLAND_DISPLAY
    export GDK_BACKEND=x11
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
    export WEBKIT_DISABLE_COMPOSITING_MODE=1
    exec ${pkgs.alcom}/bin/ALCOM "$@"
  '';
in {
  home.packages = [
    alcom-fixed

    (pkgs.makeDesktopItem {
      name = "alcom";
      desktopName = "ALCOM";
      exec = "${alcom-fixed}/bin/ALCOM";
      icon = "alcom";
      categories = [ "Utility" ];
    })
  ];

  home.file.".local/share/VRChatCreatorCompanion/settings.json".text =
    builtins.toJSON {
      pathToUnityHub = "${pkgs.unityhub}/bin/unityhub";
      unityEditorsFolder = "/home/shane/Unity/Hub/Editor";
    };
}
