{ ... }:
{
  wayland.windowManager.sway.config.output = {
    "DP-3" = {
      mode = "7680x2160@119.997Hz";
      position = "0 0";
      scale = "1";
      render_bit_depth = "10";
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

  wayland.windowManager.sway.config.workspaceOutputAssign = [
    {
      workspace = "1";
      output = "DP-3";
    }
    {
      workspace = "2";
      output = "HDMI-A-1";
    }
    {
      workspace = "3";
      output = "DP-1";
    }
  ];
}
