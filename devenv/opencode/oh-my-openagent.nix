# ./modules/opencode/oh-my-openagent.nix

{ ... }: {
  files.".opencode/oh-my-openagent.jsonc".text = builtins.toJSON {
    "$schema" = "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json";
    agents = {
      sisyphus.model = "opencode-go/kimi-k2.6";
      prometheus.model = "opencode-go/deepseek-v4-pro";
      metis.model = "opencode-go/deepseek-v4-pro";
      atlas.model = "opencode-go/kimi-k2.6";
      hephaestus = {
        model = "opencode-go/deepseek-v4-pro";
        allow_non_gpt_model = true;
      };
      oracle.model = "opencode-go/deepseek-v4-pro";
      momus.model = "opencode-go/deepseek-v4-pro";
      explore.model = "opencode-go/minimax-m2.7";
      librarian.model = "opencode-go/minimax-m2.7";
      multimodal-looker.model = "opencode-go/kimi-k2.6";
      sisyphus-junior.model = "opencode-go/qwen3.6-plus";
    };
    categories = {
      visual-engineering.model = "opencode-go/qwen3.6-plus";
      ultrabrain.model = "opencode-go/deepseek-v4-pro";
      deep.model = "opencode-go/deepseek-v4-pro";
      artistry.model = "opencode-go/qwen3.6-plus";
      quick.model = "opencode-go/minimax-m2.7";
      unspecified-high.model = "opencode-go/glm-5.1";
      unspecified-low.model = "opencode-go/kimi-k2.6";
      writing.model = "opencode-go/qwen3.6-plus";
    };
  };
}
