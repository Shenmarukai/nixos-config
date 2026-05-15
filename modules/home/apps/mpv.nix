{ ... }: {
  home.file.".config/mpv/shaders/fsr.glsl".source =
    builtins.fetchurl {
      url = "https://gist.githubusercontent.com/agyild/82219c545228d70c5604f865ce0b0ce5/raw/FSR.glsl";
      sha256 = "17lvj8bcl7fg8jmnlx2iblbhcfy4rpqvvcn3z09nvgxpqrzmkn2n";
    };

  programs.mpv = {
    enable = true;
    config = {
      vo = "gpu-next";
      profile = "gpu-hq";
      glsl-shaders = "~~/shaders/fsr.glsl";
      scale = "ewa_lanczos";
      cscale = "ewa_lanczos";
      hwdec = "auto";
    };
  };
}
