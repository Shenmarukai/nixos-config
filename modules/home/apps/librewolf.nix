{ ... }:
{
  programs.librewolf = {
    enable = true;
    settings = {
      "media.gmp-widevinecdm.enabled" = true;
      "media.gmp-provider.enabled" = true;
      "privacy.resistFingerprinting" = false;
    };
  };
}
