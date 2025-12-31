{ ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "tuigreet --remember --remember-user-session --cmd 'sway --unsupported-gpu'";
        user = "shane";
      };
    };
  };
}
