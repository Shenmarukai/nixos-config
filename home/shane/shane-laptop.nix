{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.username = "shane";
  home.homeDirectory = "/home/shane";
  home.stateVersion = "25.11";

  imports = [
    inputs.catppuccin.homeModules.catppuccin
    inputs.nixvim.homeModules.nixvim

    ../../modules/home/apps/bash.nix
    ../../modules/home/apps/git.nix
    ../../modules/home/apps/gh.nix
    ../../modules/home/apps/ghostty-config.nix
    ../../modules/home/apps/mako.nix
    ../../modules/home/apps/librewolf-mime.nix
    ../../modules/home/apps/ast-grep.nix

    ../../modules/home/apps/zsh.nix
    ../../modules/home/apps/anki.nix
    ../../modules/home/apps/ghostty-package.nix
    ../../modules/home/apps/rofi.nix
    ../../modules/home/apps/discord.nix
    ../../modules/home/apps/librewolf.nix
    ../../modules/home/apps/ungoogled-chromium.nix
    ../../modules/home/apps/lmstudio.nix
    ../../modules/home/apps/nodejs-22.nix
    ../../modules/home/apps/pulseaudio.nix
    ../../modules/home/apps/opencode.nix
    #../../modules/home/apps/opencode-desktop.nix
    ../../modules/home/apps/bitwarden-desktop.nix
    ../../modules/home/apps/bitwarden-cli.nix
    ../../modules/home/apps/jq.nix
    ../../modules/home/apps/yazi.nix
    ../../modules/home/apps/steam.nix
    ../../modules/home/apps/f3demo.nix
    ../../modules/home/apps/github-desktop.nix
    ../../modules/home/apps/ida-pro.nix
    ../../modules/home/apps/ida-pro-mcp.nix
    ../../modules/home/apps/imhex.nix
    ../../modules/home/apps/tmux.nix
    ../../modules/home/apps/hytale-launcher.nix
    ../../modules/home/apps/prismlauncher.nix
    ../../modules/home/apps/coolercontrol.nix
    ../../modules/home/apps/corectrl.nix
    ../../modules/home/apps/obsidian.nix
    ../../modules/home/apps/spotify.nix # Need to find an alternative because I don't like spotify.
    ../../modules/home/apps/lact.nix
    ../../modules/home/apps/rnote.nix
    ../../modules/home/apps/baballonia.nix
    ../../modules/home/apps/blender.nix

    ../../modules/home/dev/rust-analyzer.nix

    ../../modules/home/dev/rust-toolchain.nix
    ../../modules/home/dev/gopls.nix
    ../../modules/home/dev/lua-language-server.nix
    ../../modules/home/dev/typescript-language-server.nix
    ../../modules/home/dev/nil.nix
    ../../modules/home/dev/nixd.nix
    ../../modules/home/dev/csharp-ls.nix

    ../../modules/home/ui/fonts-jetbrainsmono.nix
    ../../modules/home/ui/vrr-status.nix
    #../../modules/home/ui/dark-theme.nix
    ../../modules/home/ui/catppuccin-theme.nix

    ../../modules/home/services/polkit-agent.nix

    ./common/optional/wm-sway.nix
    ./common/optional/ui-waybar.nix
    ./common/optional/editor-nixvim.nix

    ./hosts/shane-laptop/outputs.nix
  ];
}
