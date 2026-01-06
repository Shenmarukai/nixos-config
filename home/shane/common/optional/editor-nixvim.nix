{ config, pkgs, ... }:

let
  buildPlugin = { pname, owner, repo, rev, sha256
                 , dependencies ? [ ], doCheck ? true }:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname;
      version = rev;
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev sha256;
      };
      inherit dependencies doCheck;
    };

  customPlugins = {
    gp-nvim = buildPlugin {
      pname = "gp-nvim";
      owner = "robitx";
      repo = "gp.nvim";
      rev = "c37f154b97690c4925fef4e35ffdbf2c844b5f4e";
      sha256 = "0g41afgkjz09s400x2xvrsd4gc9lylcr581l8n3rf5ynvplpgbpq";
    };

    reticle-nvim = buildPlugin {
      pname = "reticle-nvim";
      owner = "tummetott";
      repo = "reticle.nvim";
      rev = "66bfa2b1c28fd71bb8ae4e871e0cd9e9c509ea86";
      sha256 = "0ly1k12gwpsqpjr0b1jrr0ha88xsagr9ap4zj5sflfdw7vwb9zlm";
    };

    php-nvim = buildPlugin {
      pname = "php-nvim";
      owner = "tjdevries";
      repo = "php.nvim";
      rev = "a0aa93704566d7f037966be511ebfd7cd426ceb4";
      sha256 = "0haidnf99yfnx6gnr2ba6542dmhjgb8n1swnwmw6f3a9v6jyylnh";
      dependencies = with pkgs.vimPlugins; [
        nvim-treesitter
        nvim-lspconfig
        plenary-nvim
        telescope-nvim
      ];
    };

    idascope = buildPlugin {
      pname = "idascope";
      owner = "dead-null";
      repo = "idascope";
      rev = "d305eea0e3333bbd54d7a0d05a3411ee1df000d7";
      sha256 = "1as24bm3igsj4jb093kv9f9abh4avamskysswnvw2vm5q6w79hl3";
      dependencies = with pkgs.vimPlugins; [
        telescope-nvim
        plenary-nvim
      ];
      doCheck = false;
    };

    jai-vim = buildPlugin {
      pname = "jai-vim";
      owner = "rluba";
      repo = "jai.vim";
      rev = "0cd34533dacc9f048adce5e9d02a04309e992a47";
      sha256 = "0695ibl1qfgy5g1bx3ma56gmqyrd5zskw6k1mxqfwjj0h1bnwm0k";
    };

    mason-nvim-lint = buildPlugin {
      pname = "mason-nvim-lint";
      owner = "rshkarin";
      repo = "mason-nvim-lint";
      rev = "767b8ccdddaa977bec8987fd7507b9865a279235";
      sha256 = "0rqplbsf5p9n90h9ng0hp6bpk8jzplk60br5r7rapb4cw5nk0lki";
      dependencies = with pkgs.vimPlugins; [
        mason-nvim
        nvim-lint
        plenary-nvim
      ];
      doCheck = false;
    };

    vim-with-me = buildPlugin {
      pname = "vim-with-me";
      owner = "ThePrimeagen";
      repo = "vim-with-me";
      rev = "ed0c65594a6a0f5f98f8fbb69c5c44633846ec70";
      sha256 = "1i05ivdfhm01j9mc634gfjnmmvivx5g3a2vpig2yp7vbvkh72jx3";
      doCheck = false;
    };
  };

  masonPackages = [
    {
      masonName = "lua-language-server";
      command = "${pkgs.lua-language-server}/bin/lua-language-server";
    }
    {
      masonName = "rust-analyzer";
      command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
    }
    {
      masonName = "gopls";
      command = "${pkgs.gopls}/bin/gopls";
    }
    {
      masonName = "typescript-language-server";
      command = "${pkgs.nodePackages_latest.typescript-language-server}/bin/typescript-language-server";
    }
    {
      masonName = "nixd";
      command = "${pkgs.nixd}/bin/nixd";
    }
    {
      masonName = "biome";
      command = "${pkgs.biome}/bin/biome";
    }
    {
      masonName = "csharp-language-server";
      command = "${pkgs.csharp-ls}/bin/csharp-ls";
    }
    {
      masonName = "delve";
      command = "${pkgs.delve}/bin/dlv";
    }
  ];

  masonDataFiles =
    builtins.listToAttrs (map (pkg: {
      name = "nvim/mason/bin/" + pkg.masonName;
      value = {
        executable = true;
        force = true;
        text = ''
          #!/usr/bin/env bash
          exec ${pkg.command} "$@"
        '';
      };
    }) masonPackages)
    //
    builtins.listToAttrs (map (pkg: {
      name = "nvim/mason/packages/" + pkg.masonName + "/.nix-managed";
      value = {
        force = true;
        text = "";
      };
    }) masonPackages);

  luaConfig = ''
    require('shenmarukai')
  '';

in
{

  programs.nixvim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    globals.mapleader = " ";

    opts = {
      guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20";

      number = true;
      relativenumber = false;

      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 4;
      expandtab = false;

      smartindent = true;
      wrap = false;

      swapfile = false;
      backup = false;
      undodir = "${config.home.homeDirectory}/.vim/undodir";
      undofile = true;

      hlsearch = false;
      incsearch = true;

      termguicolors = true;
      scrolloff = 8;
      signcolumn = "yes";
      isfname = "@-@";
      updatetime = 50;
      colorcolumn = "80";
    };

    plugins.treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        html
        javascript
        jsdoc
        json
        lua
        make
        markdown
        markdown_inline
        nix
        regex
        rust
        toml
        typescript
        vim
        vimdoc
        xml
        yaml
      ];
    };

    keymaps = [
      { mode = "n"; key = "<leader>pv"; action = "<cmd>Ex<CR>"; options.silent = true; }
      { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; }
      { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; }
      { mode = "n"; key = "J"; action = "mzJ`z"; }
      { mode = "n"; key = "<C-d>"; action = "<C-d>zz"; }
      { mode = "n"; key = "<C-u>"; action = "<C-u>zz"; }
      { mode = "n"; key = "n"; action = "nzzzv"; }
      { mode = "n"; key = "N"; action = "Nzzzv"; }
      { mode = "n"; key = "=ap"; action = "ma=ap'a"; }
      { mode = "n"; key = "<leader>zig"; action = "<cmd>LspRestart<CR>"; }
      { mode = "x"; key = "<leader>p"; action = ''"_dP''; }
      { mode = [ "n" "v" ]; key = "<leader>y"; action = ''"+y''; }
      { mode = "n"; key = "<leader>Y"; action = ''"+Y''; }
      { mode = [ "n" "v" ]; key = "<leader>d"; action = ''"_d''; }
      { mode = "i"; key = "<C-c>"; action = "<Esc>"; }
      { mode = "n"; key = "Q"; action = "<nop>"; }
      { mode = "n"; key = "<C-f>"; action = "<cmd>silent !tmux neww tmux-sessionizer<CR>"; }
      { mode = "n"; key = "<leader>f"; action = "<cmd>lua vim.lsp.buf.format()<CR>"; }
      { mode = "n"; key = "<C-k>"; action = "<cmd>cnext<CR>zz"; }
      { mode = "n"; key = "<C-j>"; action = "<cmd>cprev<CR>zz"; }
      { mode = "n"; key = "<leader>k"; action = "<cmd>lnext<CR>zz"; }
      { mode = "n"; key = "<leader>j"; action = "<cmd>lprev<CR>zz"; }
      { mode = "n"; key = "<leader>s"; action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>"; }
      { mode = "n"; key = "<leader>x"; action = "<cmd>!chmod +x %<CR>"; options.silent = true; }
      { mode = "n"; key = "<leader><leader>"; action = "<cmd>so<CR>"; }
      { mode = "n"; key = "<leader>u"; action = "<cmd>UndotreeToggle<CR>"; }
    ];

    extraPlugins =
      (with pkgs.vimPlugins; [
        barbar-nvim
        cellular-automaton-nvim
        catppuccin-nvim
        cloak-nvim
        cmp-buffer
        cmp-cmdline
        cmp_luasnip
        cmp-nvim-lsp
        cmp-path
        conform-nvim
        copilot-lualine
        copilot-lua
        crates-nvim
        diffview-nvim
        fidget-nvim
        friendly-snippets
        gh-nvim
        gitsigns-nvim
        github-nvim-theme
        harpoon
        FixCursorHold-nvim
        litee-nvim
        lualine-nvim
        mason-lspconfig-nvim
        mason-nvim
        mason-nvim-dap-nvim
        mini-nvim
        neogit
        neoscroll-nvim
        neotest
        neotest-golang
        neotest-rust
        nvim-cmp
        nvim-dap
        nvim-dap-go
        nvim-dap-ui
        nvim-lint
        nvim-lspconfig
        nvim-nio
        nvim-tree-lua
        nvim-treesitter-context
        nvim-web-devicons
        opencode-nvim
        peek-nvim
        plenary-nvim
        rainbow-delimiters-nvim
        render-markdown-nvim
        snacks-nvim
        telescope-nvim
        tokyonight-nvim
        trouble-nvim
        twilight-nvim
        undotree
        vim-be-good
        vim-fugitive
        which-key-nvim
        yazi-nvim
        zen-mode-nvim
        luasnip
      ]) ++ [
    customPlugins.gp-nvim
    customPlugins.reticle-nvim
    customPlugins.php-nvim
    customPlugins.idascope
    customPlugins.jai-vim
    customPlugins.mason-nvim-lint
    customPlugins.vim-with-me
  ];


    extraConfigLuaPost = luaConfig;
  };

  xdg.configFile = {
    "nvim/lua/shenmarukai/init.lua".source = ../../neovim/lua/shenmarukai/init.lua;
    "nvim/lua/shenmarukai/set.lua".source = ../../neovim/lua/shenmarukai/set.lua;
    "nvim/lua/shenmarukai/remap.lua".source = ../../neovim/lua/shenmarukai/remap.lua;
    "nvim/lua/shenmarukai/autocmds.lua".source = ../../neovim/lua/shenmarukai/autocmds.lua;
    "nvim/lua/shenmarukai/plugins/colors.lua".source = ../../neovim/lua/shenmarukai/plugins/colors.lua;
    "nvim/lua/shenmarukai/plugins/cloak.lua".source = ../../neovim/lua/shenmarukai/plugins/cloak.lua;
    "nvim/lua/shenmarukai/plugins/barbar.lua".source = ../../neovim/lua/shenmarukai/plugins/barbar.lua;
    "nvim/lua/shenmarukai/plugins/copilot.lua".source = ../../neovim/lua/shenmarukai/plugins/copilot.lua;
    "nvim/lua/shenmarukai/plugins/crates.lua".source = ../../neovim/lua/shenmarukai/plugins/crates.lua;
    "nvim/lua/shenmarukai/plugins/tree.lua".source = ../../neovim/lua/shenmarukai/plugins/tree.lua;
    "nvim/lua/shenmarukai/plugins/lualine.lua".source = ../../neovim/lua/shenmarukai/plugins/lualine.lua;
    "nvim/lua/shenmarukai/plugins/telescope.lua".source = ../../neovim/lua/shenmarukai/plugins/telescope.lua;
    "nvim/lua/shenmarukai/plugins/harpoon.lua".source = ../../neovim/lua/shenmarukai/plugins/harpoon.lua;
    "nvim/lua/shenmarukai/plugins/fugitive.lua".source = ../../neovim/lua/shenmarukai/plugins/fugitive.lua;
    "nvim/lua/shenmarukai/plugins/gh.lua".source = ../../neovim/lua/shenmarukai/plugins/gh.lua;
    "nvim/lua/shenmarukai/plugins/gp.lua".source = ../../neovim/lua/shenmarukai/plugins/gp.lua;
    "nvim/lua/shenmarukai/plugins/idascope.lua".source = ../../neovim/lua/shenmarukai/plugins/idascope.lua;
    "nvim/lua/shenmarukai/plugins/luasnip.lua".source = ../../neovim/lua/shenmarukai/plugins/luasnip.lua;
    "nvim/lua/shenmarukai/plugins/dap.lua".source = ../../neovim/lua/shenmarukai/plugins/dap.lua;
    "nvim/lua/shenmarukai/plugins/lsp.lua".source = ../../neovim/lua/shenmarukai/plugins/lsp.lua;
    "nvim/lua/shenmarukai/plugins/lint.lua".source = ../../neovim/lua/shenmarukai/plugins/lint.lua;
    "nvim/lua/shenmarukai/plugins/treesitter.lua".source = ../../neovim/lua/shenmarukai/plugins/treesitter.lua;
    "nvim/lua/shenmarukai/plugins/rainbow.lua".source = ../../neovim/lua/shenmarukai/plugins/rainbow.lua;
    "nvim/lua/shenmarukai/plugins/render.lua".source = ../../neovim/lua/shenmarukai/plugins/render.lua;
    "nvim/lua/shenmarukai/plugins/reticle.lua".source = ../../neovim/lua/shenmarukai/plugins/reticle.lua;
    "nvim/lua/shenmarukai/plugins/peek.lua".source = ../../neovim/lua/shenmarukai/plugins/peek.lua;
    "nvim/lua/shenmarukai/plugins/yazi.lua".source = ../../neovim/lua/shenmarukai/plugins/yazi.lua;
    "nvim/lua/shenmarukai/plugins/trouble.lua".source = ../../neovim/lua/shenmarukai/plugins/trouble.lua;
    "nvim/lua/shenmarukai/plugins/twilight.lua".source = ../../neovim/lua/shenmarukai/plugins/twilight.lua;
    "nvim/lua/shenmarukai/plugins/zen.lua".source = ../../neovim/lua/shenmarukai/plugins/zen.lua;
    "nvim/lua/shenmarukai/plugins/whichkey.lua".source = ../../neovim/lua/shenmarukai/plugins/whichkey.lua;
    "nvim/lua/shenmarukai/plugins/neogit.lua".source = ../../neovim/lua/shenmarukai/plugins/neogit.lua;
    "nvim/lua/shenmarukai/plugins/neoscroll.lua".source = ../../neovim/lua/shenmarukai/plugins/neoscroll.lua;
    "nvim/lua/shenmarukai/plugins/undotree.lua".source = ../../neovim/lua/shenmarukai/plugins/undotree.lua;
    "nvim/lua/shenmarukai/plugins/snacks.lua".source = ../../neovim/lua/shenmarukai/plugins/snacks.lua;
    "nvim/lua/shenmarukai/plugins/opencode.lua".source = ../../neovim/lua/shenmarukai/plugins/opencode.lua;
    "nvim/lua/shenmarukai/plugins/neotest.lua".source = ../../neovim/lua/shenmarukai/plugins/neotest.lua;
  };

  xdg.dataFile = masonDataFiles;
}
