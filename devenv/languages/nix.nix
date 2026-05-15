# ./modules/languages/nix.nix

{ ... }: {
  languages.nix = {
    enable = true;
    lsp.enable = true;
  };
}
