{ pkgs, ... }:
let
  # The fixed launcher script we made earlier
  alcom-fix = pkgs.writeShellScriptBin "alcom-fix" ''
    unset WAYLAND_DISPLAY
    export GDK_BACKEND=x11
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
    exec ${pkgs.alcom}/bin/alcom "$@"
  '';
in {
  home.packages = [
    (pkgs.alcom.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + "rm -rf $out/share/applications";
    }))
    alcom-fix
    (pkgs.makeDesktopItem {
      name = "alcom";
      desktopName = "ALCOM";
      exec = "${alcom-fix}/bin/alcom-fix";
      icon = "alcom";
    })
  ];

  # This is the "Nix way": Generating the settings file with dynamic paths
  home.file.".local/share/VRChatCreatorCompanion/settings.json".text = builtins.toJSON {
    pathToUnityHub = "${pkgs.unityhub}/bin/unityhub";
    # Point this to where Unity Hub actually installs editors on your disk
    unityEditorsFolder = "/home/shane/Unity/Hub/Editor";
    # Add other VCC settings here if needed
  };
}
