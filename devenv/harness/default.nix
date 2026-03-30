# ./modules/automation/default.nix

{ lib, ... }: {
  options.harness = {
    packageName = lib.mkOption {
      type = lib.types.str;
      default = "tauri-harness";
      description = "Package name used for dependency installation.";
    };

    opencodePlugin = lib.mkOption {
      type = lib.types.str;
      default = "tauri-harness/opencode";
      description = "OpenCode plugin entry loaded by package subpath.";
    };

    packageSpec = lib.mkOption {
      type = lib.types.str;
      default = "github:ptzoptics/tauri-harness#main";
      description = "Dependency spec used to install the harness package.";
    };

    mcpBin = lib.mkOption {
      type = lib.types.str;
      default = "tauri-harness-mcp";
      description = "CLI binary used to launch the harness MCP server.";
    };
  };

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
