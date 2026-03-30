# ./modules/automation/opencode/default.nix

{ ... }: {
  opencode = {
    enable = true;
    settings = {
      plugin = [ "@tarquinen/opencode-dcp@3.1.5" ];
    };
  };
}
