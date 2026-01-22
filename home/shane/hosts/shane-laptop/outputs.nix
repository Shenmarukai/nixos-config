{ lib, pkgs, ... }:
let
  swaymsg = "${pkgs.swayfx}/bin/swaymsg";

  dockedWorkspaceSetup = pkgs.writeShellScript "kanshi-docked-workspaces" ''
    ${swaymsg} 'workspace number 1'
    ${swaymsg} 'move workspace to output "Samsung Electric Company LU28R55 HCJT605556"'

    ${swaymsg} 'workspace number 2'
    ${swaymsg} 'move workspace to output "Samsung Electric Company LU28R55 HCJT702534"'
  '';

  undockedWorkspaceSetup = pkgs.writeShellScript "kanshi-undocked-workspaces" ''
    ${swaymsg} 'workspace number 1'
    ${swaymsg} 'move workspace to output eDP-1'
  '';
in
{
  # The shared Sway module configures desktop-specific outputs/workspace pinning.
  # On the laptop we want kanshi to fully own output + workspace placement.
  wayland.windowManager.sway.config.output = lib.mkForce { };
  wayland.windowManager.sway.config.workspaceOutputAssign = lib.mkForce [ ];

  # Ensure sway-session.target exists so kanshi starts at the right time.
  wayland.windowManager.sway.systemd.enable = true;
  wayland.windowManager.sway.systemd.variables = [
    "DISPLAY"
    "WAYLAND_DISPLAY"
    "SWAYSOCK"
    "XDG_CURRENT_DESKTOP"
  ];

  # Make sure kanshi is restarted after Sway is up and SWAYSOCK is imported.
  # This avoids the common "kanshi is running but can't talk to sway" issue.
  wayland.windowManager.sway.config.startup = lib.mkAfter [
    { command = "systemctl --user restart kanshi"; }
  ];

  services.kanshi = {
    enable = true;
    systemdTarget = "sway-session.target";

    # Use an ordered list so the "docked" profile is always considered first.
    settings = [
      {
        profile = {
          name = "docked";
          outputs = [
            {
              criteria = "Samsung Electric Company LU28R55 HCJT605556";
              mode = "3840x2160@59.996Hz";
              position = "0,0";
              scale = 1.0;
              status = "enable";
            }
            {
              criteria = "Samsung Electric Company LU28R55 HCJT702534";
              mode = "3840x2160@59.996Hz";
              position = "3840,0";
              scale = 1.0;
              status = "enable";
            }
            {
              criteria = "eDP-1";
              status = "disable";
            }
          ];
          exec = [ "${dockedWorkspaceSetup}" ];
        };
      }
      {
        profile = {
          name = "undocked";
          outputs = [
            {
              criteria = "eDP-1";
              mode = "3840x2160@60Hz";
              position = "0,0";
              scale = 1.25;
              status = "enable";
            }
          ];
          exec = [ "${undockedWorkspaceSetup}" ];
        };
      }
    ];
  };
}
