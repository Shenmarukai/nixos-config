{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wget
    git
    vim
    neovim
    zip
    unzip

    lm_sensors
    liquidctl
  ];
}
