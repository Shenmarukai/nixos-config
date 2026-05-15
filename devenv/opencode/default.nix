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

          models = {
            "gemma-4-e4b-it" = {
              name = "Gemma 4 E4B IT";
            };
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
        "git*" = "deny";
        git_git_status = "allow";
        git_git_diff = "allow";
        git_git_log = "allow";
        git_git_show = "allow";
        git_git_blame = "allow";
        git_git_reflog = "allow";
        git_git_changelog_analyze = "allow";
      };
    };

    rules = ''
    '';
  };
}
