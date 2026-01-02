{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wl-clipboard
    mako
    waybar
    tuigreet
    swaybg
    grim
    slurp
    swaylock-effects
    pipewire
  ];
}
