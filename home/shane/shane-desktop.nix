{ config, pkgs, inputs, ... }: {
  home.username = "shane";
  home.homeDirectory = "/home/shane";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    OPENCODE_MAIN_MODEL = "gpt-oss-120b";
    OPENCODE_PLAN_MODEL = "gpt-oss-120b";
    OPENCODE_SMALL_PLAN_MODEL = "nemotron-3-nano-30b-a3b";
    OPENCODE_BUILD_MODEL = "gpt-oss-120b";
    OPENCODE_SMALL_BUILD_MODEL = "nemotron-3-nano-30b-a3b";
  };

  imports = [
    inputs.nixvim.homeModules.nixvim

    ../../modules/home/apps/bash.nix
    ../../modules/home/apps/git.nix
    ../../modules/home/apps/gh.nix
    ../../modules/home/apps/ghostty-config.nix
    ../../modules/home/apps/mako.nix
    ../../modules/home/apps/librewolf-mime.nix

    ../../modules/home/apps/ghostty-package.nix
    ../../modules/home/apps/rofi.nix
    ../../modules/home/apps/discord.nix
    ../../modules/home/apps/librewolf.nix
    ../../modules/home/apps/lmstudio.nix
    ../../modules/home/apps/nodejs-22.nix
    ../../modules/home/apps/pulseaudio.nix
    ../../modules/home/apps/opencode.nix
    ../../modules/home/apps/bitwarden-desktop.nix
    ../../modules/home/apps/bitwarden-cli.nix
    ../../modules/home/apps/jq.nix
    ../../modules/home/apps/yazi.nix
    ../../modules/home/apps/steam.nix
    ../../modules/home/apps/github-desktop.nix
    ../../modules/home/apps/ida-pro.nix
    ../../modules/home/apps/imhex.nix
    ../../modules/home/apps/tmux.nix

    ../../modules/home/dev/rust-analyzer.nix
    ../../modules/home/dev/rust-toolchain.nix
    ../../modules/home/dev/gopls.nix
    ../../modules/home/dev/lua-language-server.nix
    ../../modules/home/dev/typescript-language-server.nix
    ../../modules/home/dev/nixd.nix
    ../../modules/home/dev/csharp-ls.nix

    ../../modules/home/ui/fonts-jetbrainsmono.nix
    ../../modules/home/ui/vrr-status.nix
    ../../modules/home/ui/dark-theme.nix

    ./common/optional/wm-sway.nix
    ./common/optional/ui-waybar.nix
    ./common/optional/editor-nixvim.nix

    ./hosts/shane-desktop/outputs.nix
  ];
}
