{ pkgs, inputs, ... }:
let
  swayfx = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.swayfx;
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "tuigreet --remember --remember-user-session --cmd '${swayfx}/bin/sway --unsupported-gpu'";
        user = "shane";
      };
    };
  };
}
