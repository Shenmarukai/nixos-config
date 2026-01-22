{ pkgs, ... }:
{
  home.file.".local/share/games/f3demo" = {
    source = "${pkgs.f3demo}/share/f3demo";
    recursive = true;
  };
}
