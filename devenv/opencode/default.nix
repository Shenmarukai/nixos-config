# ./modules/opencode/default.nix

{ ... }: {
  imports = [
    ./mcp
    ./oh-my-openagent.nix
  ];

  opencode = {
    enable = true;

    settings = {
      provider = {
        lmstudio = {
          npm = "@ai-sdk/openai-compatible";
          name = "LM Studio";

          options = {
            baseURL = "http://127.0.0.1:1234/v1";
          };
        };
      };

      compaction = {
        auto = true;
        prune = true;
      };

      plugin = [
        "oh-my-openagent@latest"
      ];

      permission = {
        external_directory = "ask";
      };
    };

    rules = ''
    '';
  };
}
