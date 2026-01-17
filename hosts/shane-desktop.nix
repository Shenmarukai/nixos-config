{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../hardware/shane-desktop-hardware.nix

    ../modules/system/hardware/bluetooth.nix

    ../modules/system/core/nix-core.nix
    ../modules/system/core/boot-efi.nix
    ../modules/system/core/time-nyc.nix

    ../modules/system/network/networkmanager.nix

    ../modules/system/audio/pipewire-core.nix
    ../modules/system/audio/wireplumber-x2u.nix
    ../modules/system/audio/wireplumber-usb-speakers.nix

    ../modules/system/graphics/core.nix
    ../modules/system/graphics/nvidia.nix

    ../modules/system/packages/cli-tools.nix
    ../modules/system/packages/wayland-desktop.nix
    ../modules/system/apps/appimage.nix
    ../modules/system/apps/lmstudio.nix
    ../modules/system/apps/openrgb.nix
    ../modules/system/apps/coolercontrol.nix

    ../modules/system/services/dconf.nix
    ../modules/system/services/gnome-keyring.nix
    ../modules/system/services/xdg-portal.nix
    ../modules/system/services/polkit.nix
    ../modules/system/security/pam-swaylock.nix
    ../modules/system/services/greetd-tuigreet.nix
    ../modules/system/services/uni-sync.nix
    ../modules/system/services/avahi.nix

    ../modules/system/apps/steam-hardware.nix
    ../modules/system/apps/steam-remote-play.nix

    ../modules/system/users/shane.nix
  ];

  services.uniSync = {
    enable = true;
    configs = [
      {
        deviceId = "VID:3314/PID:41218/SN:6243168001/PATH:5-10:1.1";
        syncRgb = true;
        channels = [
          {
            mode = "PWM";
            speed = 50;
          }
          {
            mode = "PWM";
            speed = 50;
          }
          {
            mode = "PWM";
            speed = 50;
          }
          {
            mode = "PWM";
            speed = 50;
          }
        ];
      }
    ];
  };

  networking.hostName = "shane-desktop";

  hardware.bluetooth.powerOnBoot = true;

  system.stateVersion = "25.11";
}
