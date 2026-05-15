# ./modules/languages/default.nix

{ ... }: {
  imports = [
    ./nix.nix
    ./lua.nix
  ];
}
