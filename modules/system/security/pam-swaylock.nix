{ ... }: {
  security.pam.services.swaylock = {
    text = ''
      auth     include login
      account  include login
      password include login
      session  include login
    '';
  };
}
