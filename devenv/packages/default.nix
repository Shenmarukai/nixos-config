# ./modules/packages/default.nix

{ ... }: {
  imports = [
    ./github-mcp-server.nix
    ./mcp-nixos.nix
  ];
}
