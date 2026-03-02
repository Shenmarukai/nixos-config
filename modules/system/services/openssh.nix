{ ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # Stronger security
      PermitRootLogin = "no";
    };
  };
}
