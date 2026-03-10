{ ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    cores    = 4;
    max-jobs = 4;

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    sandbox = true;
    substituters = [
      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };
}
