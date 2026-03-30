# ./modules/automation/mcp-servers/rag.nix

{ config, ... }:
let
  devenvRoot = config.devenv.root;
  sharedEnv = {
    DEVENV_ROOT = devenvRoot;
    DB_PATH = "./.rag/lancedb";
    CACHE_DIR = "./.rag/models";
  };
  version = "0.5.3";
in {
  claude.code.mcpServers.rag = {
    type = "stdio";
    command = "npx";
    args = [
      "-y"
      "mcp-local-rag@${version}"
    ];
    env = sharedEnv;
  };

  opencode.mcp.rag = {
    type = "local";
    command = [
      "npx"
      "-y"
      "mcp-local-rag@${version}"
    ];
    environment = sharedEnv;
  };
}
