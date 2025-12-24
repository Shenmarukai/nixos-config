{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  environment.systemPackages = with pkgs; [
    wl-clipboard
    mako
    waybar
    vim
    neovim
    wget
    git
    tuigreet
    swaybg
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
