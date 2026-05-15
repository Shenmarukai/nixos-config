{ pkgs, lib, ... }:

let
  vrcftAvaloniaAppImage = pkgs.requireFile {
    name = "VRCFaceTracking.Avalonia.1.1.1.0.x64.AppImage";
    url = "https://github.com/dfgHiatus/VRCFaceTracking.Avalonia/releases/latest";
    sha256 = "sha256-oW8tsrJfC8woL2rCVyItFk4oR8M1SlQ/Y0vA1EaOhGQ=";
  };

  vrcftAvaloniaUnwrapped = pkgs.appimageTools.wrapType2 {
    pname = "vrcfacetracking-avalonia-unwrapped";
    version = "1.1.1.0";
    src = vrcftAvaloniaAppImage;

    extraPkgs = pkgs: [
      pkgs.icu
    ];
  };

  vrcftAvalonia = pkgs.symlinkJoin {
    name = "vrcfacetracking-avalonia-1.1.1.0";

    paths = [
      vrcftAvaloniaUnwrapped
    ];

    nativeBuildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      mkdir -p $out/bin

      rm -f $out/bin/vrcfacetracking-avalonia

      makeWrapper ${vrcftAvaloniaUnwrapped}/bin/vrcfacetracking-avalonia-unwrapped \
        $out/bin/vrcfacetracking-avalonia \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pkgs.icu ]}" \
        --set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 0
    '';
  };
in
{
  home.packages = [
    vrcftAvalonia
  ];
}
