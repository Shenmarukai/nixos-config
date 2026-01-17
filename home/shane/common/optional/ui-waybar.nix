{ ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [
          "custom/vrr"
          "pulseaudio"
          "battery"
          "tray"
        ];

        "custom/vrr" = {
          exec = "vrr-status";
          interval = 2;
          return-type = "json";
          format = "VRR {icon}  ";
          format-icons = {
            on = "●";
            off = "○";
          };
          on-click = "swaymsg 'output DP-3 adaptive_sync toggle'";
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 11px;
      }

      window#waybar {
        background: #1e1e2e;
        color: #cdd6f4;
        border: 1px solid #89b4fa;
        border-radius: 10px;
        padding: 4px 8px;
      }

      #workspaces button {
        background: transparent;
        color: #7f849c;
        padding: 0 6px;
        margin: 0 2px;
      }

      #workspaces button.focused {
        background: #313244;
        color: #cdd6f4;
        border-radius: 8px;
      }

      #workspaces button.urgent {
        background: #f38ba8;
        color: #1e1e2e;
      }

      #clock,
      #battery,
      #pulseaudio,
      #tray,
      #custom-vrr {
        padding: 2px 8px;
        margin: 0 4px;
      }

      #battery.charging {
        background: #a6e3a1;
        color: #1e1e2e;
      }

      #battery.critical:not(.charging) {
        background: #f38ba8;
        color: #1e1e2e;
      }

      #pulseaudio.muted {
        background: #313244;
        color: #7f849c;
      }
    '';
  };
}
