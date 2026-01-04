{ pkgs, inputs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    package = inputs.swayfx.packages.${pkgs.system}.default;
    checkConfig = false;

    extraSessionCommands = "";

    config = {
      terminal = "ghostty";
      startup = [
        { command = "waybar"; }
        { command = "mako"; }
      ];
      keybindings = {
        "Mod4+Return" = "exec ghostty";
        "Mod4+d" = "exec rofi -show drun";
        "Mod4+b" = "exec librewolf";
        "Mod4+Shift+q" = "kill";
        "Mod4+Shift+c" = "reload";
        "Mod4+Shift+v" = "output DP-3 adaptive_sync toggle";
      };
    };

    extraConfig = ''
      blur enable
      blur_radius 7
      blur_passes 3
      corner_radius 10
      default_border pixel 2
      default_floating_border normal
      shadows enable
      shadow_blur_radius 20
      shadow_offset 0 5
      shadow_color #000000aa

      default_dim_inactive 0.3
 
      font pango:JetBrainsMono Nerd Font 11

      gaps inner 8
      gaps outer 4

      client.focused      #89b4fa #1e1e2e #cdd6f4 #89b4fa #89b4fa
      client.unfocused    #6c7086 #11111b #a6adc8 #45475a #45475a
      client.urgent       #f38ba8 #1e1e2e #cdd6f4 #f38ba8 #f38ba8

      layer_effects "waybar" {
        blur enable;
        shadows enable;
        corner_radius 10;
      }

      layer_effects "mako" {
        blur enable;
        shadows enable;
        corner_radius 10;
      }

      output DP-3 mode 7680x2160@119.997Hz
      output DP-3 pos 0 0
      output DP-3 scale 1

      output HDMI-A-1 mode 1920x1080@60.000Hz
      output HDMI-A-1 pos 2880 2160
      output HDMI-A-1 scale 1

      output DP-1 mode 2560x1440@119.998Hz
      output DP-1 pos 7680 720
      output DP-1 scale 1

      workspace 1 output DP-3
      workspace 2 output HDMI-A-1
      workspace 3 output DP-1
    '';
  };
}
