args@{
  home-manager,
  pkgsFor,
  inputs,
  self,
  ...
}:
let
  mkHome =
    host:
    home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor "x86_64-linux";
      extraSpecialArgs = { inherit inputs; };
      modules = [ (self + "/home/shane/${host}.nix") ];
    };
in
{
  homeConfigurations = {
    "shane@shane-desktop" = mkHome "shane-desktop";
    "shane@shane-laptop" = mkHome "shane-laptop";
  };
}
