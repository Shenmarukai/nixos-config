args@{ overlayDefault, nixpkgs-wayland, ... }:
{
  overlays.default = overlayDefault;

  nixpkgs.overlays = [ nixpkgs-wayland.overlay ];
}
