# ./modules/automation/mcp-servers/default.nix

{ ... }: {
  imports = [
    ./git.nix
    ./devenv.nix
    ./nixos.nix
    ./github.nix
  ];
}
