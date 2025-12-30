{ ... }: {
  wayland.windowManager.sway.extraConfig = ''
    # Internal 4K laptop panel
    output eDP-1 mode 3840x2160@60.000Hz
    output eDP-1 scale 1.5

    workspace 1 output eDP-1
  '';
}
