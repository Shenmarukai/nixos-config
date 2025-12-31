{ pkgs, inputs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false;
    wrapperFeatures.gtk = true;

    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
      export WLR_RENDERER=vulkan
    '';

    config = rec {
      modifier = "Mod4";
      terminal = "ghostty";

      startup = [
        { command = "waybar"; }
        { command = "mako"; }
      ];

      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec rofi -show drun";
        "${modifier}+b" = "exec librewolf";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+v" = "output DP-3 adaptive_sync toggle";
        "${modifier}+l" = "exec swaylock-effects -f";

        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";

        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };
    };

    extraConfig = ''
      blur enable
      blur_radius 7
      corner_radius 10
      shadows enable
    '';
  };
}
