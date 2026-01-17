inputs:
let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs) self;

  systems = [ "x86_64-linux" ];
  forEachSystem = lib.genAttrs systems;

  overlayDefault = import (self + "/overlays/default.nix");
  overlayIdaProSetup = import (self + "/overlays/ida-pro-setup-overlay.nix");
  overlayList = [
    inputs.ida-pro-overlay.overlays.default
    overlayIdaProSetup
    overlayDefault
  ];

  pkgsFor =
    system:
    import inputs.nixpkgs {
      inherit system;
      overlays = overlayList;
    };
in
{
  inherit
    lib
    systems
    forEachSystem
    pkgsFor
    overlayDefault
    overlayIdaProSetup
    overlayList
    ;
}
