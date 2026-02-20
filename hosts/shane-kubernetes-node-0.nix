{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../hardware/shane-kubernetes-node-0-hardware.nix

    ../modules/system/hardware/bluetooth.nix
    ../modules/system/hardware/usb.nix

    ../modules/system/core/nix-core.nix
    ../modules/system/core/boot-efi.nix
    ../modules/system/core/time-nyc.nix

    ../modules/system/network/networkmanager.nix

    ../modules/system/graphics/core.nix
    ../modules/system/graphics/nvidia.nix

    ../modules/system/users/kubernetes.nix
  ];

  networking.hostName = "shane-kubernetes-node-0";

  hardware.bluetooth.powerOnBoot = true;

  system.stateVersion = "25.11";
}
