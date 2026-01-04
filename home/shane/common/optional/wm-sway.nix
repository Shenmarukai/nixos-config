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

      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size = 11.0;
      };

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

      modes = {
        resize = {
          "Down" = "resize grow height 10 px";
          "Escape" = "mode default";
          "Left" = "resize shrink width 10 px";
          "Return" = "mode default";
          "Right" = "resize grow width 10 px";
          "Up" = "resize shrink height 10 px";
          "h" = "resize shrink width 10 px";
          "j" = "resize grow height 10 px";
          "k" = "resize shrink height 10 px";
          "l" = "resize grow width 10 px";
        };
      };

      gaps = {
        inner = 8;
        outer = 4;
      };

      colors = {
        focused = {
          border = "#89b4fa";
          background = "#1e1e2e";
          text = "#cdd6f4";
          indicator = "#89b4fa";
          childBorder = "#89b4fa";
        };
        unfocused = {
          border = "#6c7086";
          background = "#11111b";
          text = "#a6adc8";
          indicator = "#45475a";
          childBorder = "#45475a";
        };
        urgent = {
          border = "#f38ba8";
          background = "#1e1e2e";
          text = "#cdd6f4";
          indicator = "#f38ba8";
          childBorder = "#f38ba8";
        };
      };

      bars = [
        {
          fonts = {
            names = [ "monospace" ];
            size = 8.0;
          };

          mode = "dock";
          hiddenState = "hide";
          position = "bottom";

          statusCommand = "${pkgs.i3status}/bin/i3status";
          swaybarCommand = "${pkgs.swayfx}/bin/swaybar";

          workspaceButtons = true;
          stripWorkspaceNumbers = false;
          trayOutput = "primary";

          colors = {
            background = "#000000";
            statusline = "#ffffff";
            separator = "#666666";

            focusedWorkspace = {
              border = "#4c7899";
              background = "#285577";
              text = "#ffffff";
            };
            activeWorkspace = {
              border = "#333333";
              background = "#5f676a";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              border = "#333333";
              background = "#222222";
              text = "#888888";
            };
            urgentWorkspace = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
            };
            bindingMode = {
              border = "#2f343a";
              background = "#900000";
              text = "#ffffff";
            };
          };
        }
      ];

      output = {
        "DP-3" = {
          mode = "7680x2160@119.997Hz";
          position = "0 0";
          scale = "1";
        };
        "HDMI-A-1" = {
          mode = "1920x1080@60.000Hz";
          position = "2880 2160";
          scale = "1";
        };
        "DP-1" = {
          mode = "2560x1440@119.998Hz";
          position = "7680 720";
          scale = "1";
        };
      };

      workspaceOutputAssign = {
        "1" = "DP-3";
        "2" = "HDMI-A-1";
        "3" = "DP-1";
      };
    };

    extraConfig = ''
      font pango:monospace 8.000000
      floating_modifier Mod1
      default_border normal 2
      default_floating_border normal 2
      hide_edge_borders none
      focus_wrapping no
      focus_follows_mouse yes
      focus_on_window_activation smart
      mouse_warping output
      workspace_layout default
      workspace_auto_back_and_forth no

      client.focused #4c7899 #285577 #ffffff #2e9ef4 #285577
      client.focused_inactive #333333 #5f676a #ffffff #484e50 #5f676a
      client.unfocused #333333 #222222 #888888 #292d2e #222222
      client.urgent #2f343a #900000 #ffffff #900000 #900000
      client.placeholder #000000 #0c0c0c #ffffff #000000 #0c0c0c
      client.background #ffffff

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
    '';
  };
}
