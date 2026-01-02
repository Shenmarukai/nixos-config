args@{ lib, overlayList, home-manager, inputs, self, ... }:
let
  mkHost = { host, homeModule }:
    lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        {
          nixpkgs.hostPlatform = "x86_64-linux";
          nixpkgs.overlays = overlayList;
        }
        (self + "/hosts/${host}.nix")
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            users.shane = import (self + "/home/shane/${homeModule}.nix");
            backupFileExtension = "backup";
          };
        }
      ];
    };
in
{
  nixosConfigurations.shane-desktop = mkHost {
    host = "shane-desktop";
    homeModule = "shane-desktop";
  };

  nixosConfigurations.shane-laptop = mkHost {
    host = "shane-laptop";
    homeModule = "shane-laptop";
  };
}
