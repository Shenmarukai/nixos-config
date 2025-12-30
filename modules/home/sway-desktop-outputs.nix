{ ... }: {
  wayland.windowManager.sway.extraConfig = ''
    # Desktop triple-monitor layout
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
}
