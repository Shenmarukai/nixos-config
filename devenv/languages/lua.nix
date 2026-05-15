# ./modules/languages/lua.nix

{ ... }: {
  languages.lua = {
    enable = true;
    lsp.enable = true;
  };
}

