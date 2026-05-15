{ ... }: {
  programs.gamemode = {
    enable = true;
    settings = {
      gpu = {
        apply_gpu_optimizations = "no"; # Let the NVIDIA driver handle VRR sync
      };
      general = {
        renice = 0; # Prevents priority shifts that can break Sway's scanout
      };
    };
  };
}
