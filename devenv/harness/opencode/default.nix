# ./modules/automation/opencode/default.nix

{ ... }: {
  opencode = {
    enable = true;

    settings = {
      provider = {
        lmstudio = {
          npm  = "@ai-sdk/openai-compatible";
          name = "LM Studio";

          options = {
            baseURL = "http://127.0.0.1:1234/v1";
          };
        };
      };

      compaction = {
        auto  = true;
        prune = true;
      };

      plugin = [
        "opencode-lmstudio@0.3.0"
        "@tarquinen/opencode-dcp@3.1.5"
      ];

      agent = {
        plan.disable     = true;
        build.disable    = true;
        general.disable  = true;
        explore.disable  = true;
      };
    };
  };
}
