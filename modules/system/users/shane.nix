{ pkgs, ... }:
{
  users.users.shane = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "corectrl"
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
    packages = with pkgs; [
      tree
    ];
  };

  nix.settings.trusted-users = [ "root" "shane" ];

  programs.light.enable = true;

  environment.variables = {
    NIX_IDADIR = "${pkgs.ida-pro}/opt";
  };
}
