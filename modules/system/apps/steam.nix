{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        gamemode
        nvidia-vaapi-driver
      ];
      extraProfile = ''
        unset TZ
      '';
    };
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
