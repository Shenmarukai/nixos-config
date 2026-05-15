# ./modules/opencode/oh-my-openagent.nix

{ ... }:
let
  provider = "lmstudio";
  localModel = "gemma-4-e4b-it";
in {
  files.".opencode/oh-my-openagent.jsonc".text = builtins.toJSON {
    "$schema" = "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/v4.0.0/assets/oh-my-opencode.schema.json";
    team_mode = {
      enabled               = true;
      max_parallel_members  = 4;
      max_members           = 8;
      tmux_visualization    = true;
    };
    #agents = {
    #  sisyphus.model          = "${provider}/kimi-k2.6";
    #  prometheus.model        = "${provider}/deepseek-v4-pro";
    #  metis.model             = "${provider}/deepseek-v4-pro";
    #  atlas.model             = "${provider}/kimi-k2.6";
    #  hephaestus = {
    #    model                 = "${provider}/deepseek-v4-pro";
    #    allow_non_gpt_model   = true;
    #  };
    #  oracle.model            = "${provider}/deepseek-v4-pro";
    #  momus.model             = "${provider}/deepseek-v4-pro";
    #  explore.model           = "${provider}/minimax-m2.7";
    #  librarian.model         = "${provider}/minimax-m2.7";
    #  multimodal-looker.model = "${provider}/kimi-k2.6";
    #  sisyphus-junior.model   = "${provider}/qwen3.6-plus";
    #};
    agents = {
      sisyphus.model          = "${provider}/${localModel}";
      prometheus.model        = "${provider}/${localModel}";
      metis.model             = "${provider}/${localModel}";
      atlas.model             = "${provider}/${localModel}";
      hephaestus = {
        model                 = "${provider}/${localModel}";
        allow_non_gpt_model   = true;
      };
      oracle.model            = "${provider}/${localModel}";
      momus.model             = "${provider}/${localModel}";
      explore.model           = "${provider}/${localModel}";
      librarian.model         = "${provider}/${localModel}";
      multimodal-looker.model = "${provider}/${localModel}";
      sisyphus-junior.model   = "${provider}/${localModel}";
    };
    #categories = {
    #  visual-engineering.model = "${provider}/qwen3.6-plus";
    #  ultrabrain.model         = "${provider}/deepseek-v4-pro";
    #  deep.model               = "${provider}/deepseek-v4-pro";
    #  artistry.model           = "${provider}/qwen3.6-plus";
    #  quick.model              = "${provider}/minimax-m2.7";
    #  unspecified-high.model   = "${provider}/glm-5.1";
    #  unspecified-low.model    = "${provider}/kimi-k2.6";
    #  writing.model            = "${provider}/qwen3.6-plus";
    #};
    categories = {
      visual-engineering.model = "${provider}/${localModel}";
      ultrabrain.model         = "${provider}/${localModel}";
      deep.model               = "${provider}/${localModel}";
      artistry.model           = "${provider}/${localModel}";
      quick.model              = "${provider}/${localModel}";
      unspecified-high.model   = "${provider}/${localModel}";
      unspecified-low.model    = "${provider}/${localModel}";
      writing.model            = "${provider}/${localModel}";
    };
  };
}
