{ pkgs, inputs, ... }: {
  home.packages = [
    pkgs.ghostty
    pkgs.rofi
    pkgs.discord
    pkgs.librewolf
    pkgs.nodejs_22
    pkgs.pulseaudio
    inputs.opencode.packages.${pkgs.system}.default

    pkgs.bitwarden-desktop
    pkgs.bitwarden-cli
    pkgs.jq
  ];
}
