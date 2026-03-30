# ./modules/automation/mcp-servers/nixos.nix

{ config, ... }:
let
  devenvRoot = config.devenv.root;
  sharedEnv = {
    DEVENV_ROOT = devenvRoot;
  };
in {
  claude.code.mcpServers.nixos = {
    type = "stdio";
    command = "mcp-nixos";
    env = sharedEnv;
  };

  opencode.mcp.nixos = {
    type = "local";
    command = [ "mcp-nixos" ];
    environment = sharedEnv;
  };
}
