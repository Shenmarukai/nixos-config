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
    '';
  };
}
