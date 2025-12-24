{ pkgs, ... }: {
  users.users.shane = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [ tree ];
  };
}
