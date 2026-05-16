# ./modules/scripts/default.nix

{ ... }: {
  imports = [
    ./nix-store-add-files.nix
  ];
}
