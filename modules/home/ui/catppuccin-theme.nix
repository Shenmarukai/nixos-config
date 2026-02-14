{ pkgs, lib, ... }: # Add lib here
{
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";
  catppuccin.accent = "blue";

  # Disable any automated icon attempts that might be causing conflicts
  # catppuccin.papirus.enable = false;

  gtk = {
    enable = true;

    theme = {
      name = "catppuccin-mocha-blue-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "blue" ];
        variant = "mocha";
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = lib.mkForce (pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "blue";
      });
    };
  };

  catppuccin.kvantum.enable = true;
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
