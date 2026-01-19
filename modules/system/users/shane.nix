{ pkgs, ... }:
{
  users.users.shane = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
    ];
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
    packages = with pkgs; [ tree ];
  };

  programs.light.enable = true;
}
