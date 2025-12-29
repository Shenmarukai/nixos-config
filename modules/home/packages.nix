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

    # Language servers provided declaratively
    pkgs.rust-analyzer
    pkgs.gopls
    pkgs.lua-language-server
    pkgs.nodePackages_latest.typescript-language-server
    pkgs.biome
    pkgs.csharp-ls

    # Linters / formatters
    pkgs.clang-tools
    pkgs.cpplint
    pkgs.cppcheck
    pkgs.checkmake

    # Debugger + toolchains
    pkgs.delve
    pkgs.rustc
    pkgs.cargo

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
