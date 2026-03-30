# ./modules/automation/default.nix

{ ... }: {
  imports = [
    ./claude
    ./opencode
    ./permissions
    ./mcp-servers
    ./agents
    ./skills
    ./commands
  ];
}
