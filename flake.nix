{
  description = "Shenmarukai's NixOS Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "github:sst/opencode?ref=v1.0.223";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-config = {
      url = "path:../neovim-config";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, neovim-config, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      systems = [ "x86_64-linux" ];
      forEachSystem = lib.genAttrs systems;

      overlayDefault = import ./overlays/default.nix;
      overlayList = [ overlayDefault ];

      pkgsFor = system:
        import nixpkgs {
          inherit system;
          overlays = overlayList;
        };
    in
    {
      nixosConfigurations.shane-desktop = lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs.hostPlatform = "x86_64-linux";
            nixpkgs.overlays = overlayList;
          }
          ./hosts/shane-desktop.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.shane = import ./home/shane/shane-desktop.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };

      nixosConfigurations.shane-laptop = lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs.hostPlatform = "x86_64-linux";
            nixpkgs.overlays = overlayList;
          }
          ./hosts/shane-laptop.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.shane = import ./home/shane/shane-laptop.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };

      homeConfigurations = {
        "shane@shane-desktop" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "x86_64-linux";
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home/shane/shane-desktop.nix ];
        };
        "shane@shane-laptop" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "x86_64-linux";
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home/shane/shane-laptop.nix ];
        };
      };

      overlays.default = overlayDefault;

      packages = forEachSystem (system:
        let pkgs = pkgsFor system;
        in import ./pkgs { inherit pkgs inputs; });

      formatter = forEachSystem (system:
        let pkgs = pkgsFor system;
        in pkgs.nixfmt-rfc-style);

      devShells = forEachSystem (system:
        let pkgs = pkgsFor system;
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              git
              home-manager
              nixd
              nixfmt-rfc-style
            ];
          };
        });
    };
}
