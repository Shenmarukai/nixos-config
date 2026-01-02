{ ... }: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      theme = "Catppuccin Mocha";
      font-size = 12;
      window-decoration = false;
    };
  };
}
