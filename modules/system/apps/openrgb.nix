{ ... }: {
  services.hardware.openrgb = {
    enable = true;
    startupProfile = "default.orp";
  };
}
