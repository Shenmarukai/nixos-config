{ ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;

    powerManagement.enable = true;
    powerManagement.finegrained = false;

    # GPU modes: keep this module for NVIDIA-only (prime.sync), swap to
    # prime.offload.{enable,enableOffloadCmd} for Intel primary + NVIDIA offload,
    # or drop this module + set services.xserver.videoDrivers = [ "intel" ] for Intel-only.
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  boot.kernelParams = [
    "nvidia_drm.modeset=1"
  ];
}
