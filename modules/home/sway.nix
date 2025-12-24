{ pkgs, inputs, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.swayfx;
    checkConfig = false;

    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
      export WLR_RENDERER=vulkan
    '';

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
      corner_radius 10
      shadows enable

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
