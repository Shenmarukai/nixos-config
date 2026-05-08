# ./modules/automation/mcp-servers/devenv.nix

{ config, ... }:
let
  devenvRoot = config.devenv.root;
  sharedEnv = {
    DEVENV_ROOT = devenvRoot;
  };
in {
  claude.code.mcpServers.devenv = {
    type = "stdio";
    command = "devenv";
    args = [ "mcp" ];
    env = sharedEnv;
  };

  opencode.mcp.devenv = {
    type = "local";
    command = [ "devenv" "mcp" ];
    environment = sharedEnv;
  };
}
