{ pkgs, ... }: {
  users.users.shane = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
    packages = with pkgs; [ tree ];
  };

  programs.light.enable = true;
}
