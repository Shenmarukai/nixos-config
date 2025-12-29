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

    (pkgs.writeShellScriptBin "vrr-status" ''
      state=$(
        swaymsg -r -t get_outputs |
        jq -r '.[] | select(.name=="DP-3") | .adaptive_sync_status'
      )

      if [ "$state" = "enabled" ]; then
        alt="on"
      else
        alt="off"
      fi

      printf '{"text":"%s","alt":"%s"}\n' "$alt" "$alt"
    '')
  ];
}
