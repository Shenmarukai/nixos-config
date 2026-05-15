# ./modules/automation/mcp-servers/tauri.nix

{ ... }: {
  opencode.mcp.git = {
    type = "local";
    command = [
      "npx"
      "-y"
      "@cyanheads/git-mcp-server@2.15.1"
    ];
    environment = {
      MY_ENV_VAR = "my_env_var_value";
    };
  };
}

