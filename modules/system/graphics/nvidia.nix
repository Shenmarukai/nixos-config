{ ... }:
{
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;

    powerManagement.enable = true;
    powerManagement.finegrained = false;

    prime = {
      offload.enable = true;
      #sync.enable = true;

      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
      # amdgpuBusId = "PCI:5@0:0:0"; # If you have an AMD iGPU
    };
  };

  boot.kernelParams = [
    "nvidia_drm.modeset=1"
  ];

  services.xserver.deviceSection = ''
    Option "Coolbits" "12"
  '';
}
