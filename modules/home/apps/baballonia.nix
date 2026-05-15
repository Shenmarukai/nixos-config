{ pkgs, inputs, ... }: {
  home.packages = [
    inputs.baballonia.packages.${pkgs.system}.default
  ] ++ (with pkgs; [
    v4l-utils
    psmisc
  ]);

  xdg.userDirs = {
    enable = true;
    documents = "$HOME/Documents";
  };
}
