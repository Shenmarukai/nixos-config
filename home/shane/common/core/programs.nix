{ ... }: {
  services.mako.enable = true;

  programs.bash.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "Shenmarukai";
      email = "shanemulc@comcast.net";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      theme = "Catppuccin Mocha";
      font-size = 12;
      window-decoration = false;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "librewolf.desktop" ];
      "x-scheme-handler/http" = [ "librewolf.desktop" ];
      "x-scheme-handler/https" = [ "librewolf.desktop" ];
    };
  };
}
