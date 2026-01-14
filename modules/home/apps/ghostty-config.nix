{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      theme = "Catppuccin Mocha";
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
      window-decoration = false;
      command = "${pkgs.tmux}/bin/tmux";
    };
  };
}
