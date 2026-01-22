{ pkgs, inputs, ... }:
let
  lockScript = pkgs.writeShellScriptBin "lock-screen" ''
    exec ${pkgs.swaylock-effects}/bin/swaylock \
      --screenshots \
      --clock \
      --indicator \
      --indicator-radius 110 \
      --indicator-thickness 8 \
      --effect-blur 7x5 \
      --effect-vignette 0.5:0.5 \
      --fade-in 0.2 \
      --font "JetBrainsMono Nerd Font" \
      --font-size 18 \
      --color 11111bff \
      --ring-color 89b4fa \
      --ring-ver-color 89b4fa \
      --ring-clear-color 6c7086 \
      --ring-wrong-color f38ba8 \
      --inside-color 11111bcc \
      --inside-ver-color 11111bcc \
      --inside-wrong-color 11111bcc \
      --line-color 00000000 \
      --separator-color 00000000 \
      --text-color cdd6f4 \
      --text-ver-color cdd6f4 \
      --text-wrong-color f38ba8 \
      --key-hl-color b4befe \
      --bs-hl-color f38ba8
  '';
  lockCommand = "${lockScript}/bin/lock-screen";
in
{
  home.packages = with pkgs; [
    swaylock-effects
    swayidle
  ];

  services.swayidle = {
    enable = true;
    extraArgs = [ "-w" ];
    events = [
      {
        event = "lock";
        command = lockCommand;
      }
      {
        event = "before-sleep";
        command = lockCommand;
      }
    ];
    timeouts = [
      {
        timeout = 600;
        command = lockCommand;
      }
    ];
  };

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
        "${modifier}+l" = "exec ${lockCommand}";

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

          workspaceButtons = true;
          trayOutput = "DP-3";

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

    };

    extraConfig = ''
      font pango:monospace 8.000000
      floating_modifier Mod1
      hide_edge_borders none
      focus_wrapping no
      focus_follows_mouse yes
      focus_on_window_activation smart
      mouse_warping output
      workspace_layout default
      workspace_auto_back_and_forth no

      client.focused #89b4fa #313244 #cdd6f4 #89b4fa #313244
      client.focused_inactive #6c7086 #1e1e2e #a6adc8 #45475a #1e1e2e
      client.unfocused #6c7086 #11111b #a6adc8 #313244 #11111b
      client.urgent #f38ba8 #1e1e2e #cdd6f4 #f38ba8 #1e1e2e
      client.placeholder #000000 #0c0c0c #ffffff #000000 #0c0c0c
      client.background #1e1e2e

      blur enable
      blur_radius 7
      blur_passes 3
      corner_radius 10
      default_border pixel 3
      default_floating_border normal 3
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

      output * bg #11111b solid_color
    '';
  };
}
