# ./modules/automation/mcp-servers/default.nix

{ ... }: {
  imports = [
    ./devenv.nix
    ./nixos.nix
    ./rag.nix
  ];
}
