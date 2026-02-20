{ pkgs, ... }:
{
  users.users.kubernetes = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
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
}
