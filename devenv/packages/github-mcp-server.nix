# ./modules/packages/github-mcp-server.nix

{ pkgs, ... }: {
  packages = with pkgs; [
    github-mcp-server
  ];
}
