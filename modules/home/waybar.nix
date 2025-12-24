{ ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "custom/vrr" "pulseaudio" "battery" "tray" ];

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
  };
}
