inputs:
let
  inherit (inputs.nixpkgs) lib;
  inherit (inputs) self;

  systems = [ "x86_64-linux" ];
  forEachSystem = lib.genAttrs systems;

  overlayDefault = import (self + "/overlays/default.nix");
  overlayList = [ overlayDefault ];

  pkgsFor = system:
    import inputs.nixpkgs {
      inherit system;
      overlays = overlayList;
    };
in
{
  inherit lib systems forEachSystem pkgsFor overlayDefault overlayList;
}
