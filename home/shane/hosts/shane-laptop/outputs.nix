{ ... }:
{
  wayland.windowManager.sway.extraConfig = ''
    # Internal 4K laptop panel
    output eDP-1 mode 3840x2160@60.000Hz
    #output eDP-1 pos 0 0
    output eDP-1 scale 1.25

    # External 4K display panel
    output DP-8 mode 3840x2160@59.997Hz
    #output DP-8 pos  0 2160
    output DP-8 scale 1

    # External 4K display panel
    output DP-10 mode 3840x2160@59.997Hz
    #output DP-10 pos -3840 2160
    output DP-10 scale 1

    workspace 1 output eDP-1
    workspace 2 output DP-8
    workspace 3 output DP-10
  '';
}
