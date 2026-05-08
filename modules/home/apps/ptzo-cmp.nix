{ pkgs, lib, ... }:

let
  ptzoCMPAppImage = pkgs.requireFile {
    name = "Camera-Management-Platform-1.9.7.AppImage";
    url = "Run `nix store add-file MyApp.AppImage` to provide this AppImage";
    sha256 = "sha256-z++32sgBxNBvPY9duY2U9ta5FxL9rnTg4kaWVyQ8Rkg";
  };

  ptzoCMP = pkgs.appimageTools.wrapType2 {
    pname = "ptzo-cmp";
    version = "1.0.0";
    src = ptzoCMPAppImage;
  };
in
{
  home.packages = [ ptzoCMP ];
}
