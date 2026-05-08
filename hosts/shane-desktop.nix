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
    ../modules/system/hardware/usb.nix

    ../modules/system/core/nix-core.nix
    ../modules/system/core/boot-efi.nix
    ../modules/system/core/time-nyc.nix

    ../modules/system/network/networkmanager.nix

    ../modules/system/audio/pipewire-core.nix
    ../modules/system/audio/wireplumber-x2u.nix
    ../modules/system/audio/wireplumber-usb-speakers.nix

    ../modules/system/graphics/core.nix
    ../modules/system/graphics/nvidia.nix

    ../modules/system/apps/home-manager.nix

    ../modules/system/packages/cli-tools.nix
    ../modules/system/packages/wayland-desktop.nix
    ../modules/system/packages/direnv.nix
    ../modules/system/packages/devenv.nix
    ../modules/system/apps/nix-output-monitor.nix
    ../modules/system/apps/zsh.nix
    ../modules/system/apps/appimage.nix
    ../modules/system/apps/docker-rootless.nix
    ../modules/system/apps/llama-cpp.nix
    #../modules/system/apps/lmstudio.nix
    ../modules/system/apps/openrgb.nix
    ../modules/system/apps/parted.nix
    ../modules/system/apps/coolercontrol.nix
    ../modules/system/apps/corectrl.nix
    ../modules/system/apps/cpupower.nix
    ../modules/system/apps/liquidctl.nix
    #../modules/system/apps/ssh.nix
    ../modules/system/apps/sops.nix

    ../modules/system/services/udev.nix
    ../modules/system/services/dbus.nix
    ../modules/system/services/dconf.nix
    ../modules/system/services/gnome-keyring.nix
    ../modules/system/services/xdg-portal.nix
    ../modules/system/services/polkit.nix
    ../modules/system/security/pam-swaylock.nix
    ../modules/system/services/greetd-tuigreet.nix
    ../modules/system/services/uni-sync.nix
    ../modules/system/services/avahi.nix
    ../modules/system/services/resolved.nix
    ../modules/system/services/coolercontrol.nix
    ../modules/system/services/lact.nix
    ../modules/system/services/openssh.nix

    ../modules/system/apps/steam-hardware.nix
    ../modules/system/apps/steam-remote-play.nix

    ../modules/system/users/users.nix
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

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "shane-desktop";

  hardware.bluetooth.powerOnBoot = true;

  nix.settings = {
    cores    = 8;
    max-jobs = 4;
  };

  system.stateVersion = "25.11";
}
