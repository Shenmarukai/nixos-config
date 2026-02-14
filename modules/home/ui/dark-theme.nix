{ pkgs, ... }:
{
  #gtk = {
  #  enable = true;
  #  theme = {
  #    name = "Adwaita-dark";
  #    package = pkgs.gnome-themes-extra;
  #  };
  #  iconTheme = {
  #    name = "Adwaita";
  #    package = pkgs.gnome-themes-extra;
  #  };
  #};

  #qt = {
  #  enable = true;
  #  platformTheme.name = "gtk";
  #  style = {
  #    name = "adwaita-dark";
  #    package = pkgs.adwaita-qt;
  #  };
  #};

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.catppuccin-gtk;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.catppuccin-gtk;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "catppuccin";
      package = pkgs.catppuccin-qt5ct;
    };
  };

  home.sessionVariables = {
    GTK_THEME = "Adwaita-dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };
}
