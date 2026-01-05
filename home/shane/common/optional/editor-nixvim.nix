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
    -- Helper utilities and autocommands migrated from the legacy Lua config
    local augroup = vim.api.nvim_create_augroup
    local ShenmarukaiGroup = augroup('Shenmarukai', {})
    local yank_group = augroup('HighlightYank', {})
    local autocmd = vim.api.nvim_create_autocmd
    
    function R(name)
      require('plenary.reload').reload_module(name)
    end
    
    function SmallTabLanguage(filetype)
      if filetype == 'html'
          or filetype == 'css'
          or filetype == 'javascript'
          or filetype == 'typescript'
          or filetype == 'javascriptreact'
          or filetype == 'typescriptreact'
          or filetype == 'json'
          or filetype == 'xml' then
        return true
      end
    end
    
    function MediumTabLanguage(filetype)
      if filetype == 'lua'
          or filetype == 'python'
          or filetype == 'c'
          or filetype == 'c++'
          or filetype == 'c#'
          or filetype == 'rust'
          or filetype == 'markdown' then
        return true
      end
    end
    
    function LargeTabLanguage(_)
      return false
    end
    
    local function ColorMyPencils() end
    
    vim.filetype.add({
      extension = {
        templ = 'templ',
      },
    })
    
    vim.g.barbar_auto_setup = false
    vim.g.netrw_browse_split = 0
    vim.g.netrw_banner = 0
    vim.g.netrw_winsize = 25
    
    local function enable_inlay_hints(bufnr)
      if vim.lsp.inlay_hint then
        local ok = pcall(vim.lsp.inlay_hint, bufnr, true)
        if not ok then
          pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
        end
      end
    end
    
    autocmd('VimEnter', {
      callback = function()
        local ok, api = pcall(require, 'nvim-tree.api')
        if ok then
          api.tree.open()
        end
        pcall(vim.cmd.colorscheme, 'catppuccin')
      end,
    })
    
    autocmd('TextYankPost', {
      group = yank_group,
      pattern = '*',
      callback = function()
        vim.highlight.on_yank({
          higroup = 'IncSearch',
          timeout = 40,
        })
      end,
    })
    
    autocmd({ 'BufWritePre' }, {
      group = ShenmarukaiGroup,
      pattern = '*',
      command = [[%s/\s\+$//e]],
    })
    
    autocmd('LspAttach', {
      group = ShenmarukaiGroup,
      callback = function(e)
        local filetype = vim.bo.filetype
        vim.diagnostic.config({ virtual_text = true })
        vim.diagnostic.show()
        enable_inlay_hints(e.buf)
        if filetype ~= 'NvimTree' then
          vim.opt.list = true
          vim.opt.listchars = {
            tab = '│ ',
            leadmultispace = '│   ',
            trail = '·',
            extends = '»',
            precedes = '«',
            conceal = '*',
          }
        else
          vim.opt.list = true
          vim.opt.listchars = {
            tab = '│ ',
            leadmultispace = '│ ',
            extends = '»',
            precedes = '«',
            conceal = '*',
          }
        end
        local opts = { buffer = e.buf }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
        vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
      end,
    })
    
    autocmd('BufEnter', {
      group = ShenmarukaiGroup,
      callback = function()
        pcall(vim.cmd.colorscheme, 'catppuccin')
        vim.opt_local.expandtab = false
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
      end,
    })
    
    autocmd({ 'ModeChanged', 'BufEnter' }, {
      group = ShenmarukaiGroup,
      callback = function()
        local mode = vim.fn.mode(1)
        local filetype = vim.bo.filetype
        if filetype ~= 'NvimTree' then
          if mode == 'i' or mode == 'v' or mode == 'V' or mode == '\x16' then
            vim.opt_local.list = true
            vim.opt_local.listchars = {
              tab = '┼─',
              space = '·',
              lead = '·',
              leadmultispace = '│···',
              trail = '·',
              eol = '↲',
              nbsp = '␣',
              extends = '»',
              precedes = '«',
              conceal = '*',
            }
          elseif mode == 'n' then
            vim.opt_local.list = true
            vim.opt_local.listchars = {
              tab = '│ ',
              leadmultispace = '│   ',
              trail = '·',
              extends = '»',
              precedes = '«',
              conceal = '*',
            }
          end
        else
          if mode == 'i' or mode == 'n' or mode == 'v' or mode == 'V' or mode == '\x16' then
            vim.opt.list = true
            vim.opt.listchars = {
              tab = '│ ',
              leadmultispace = '│ ',
              extends = '»',
              precedes = '«',
              conceal = '*',
            }
          end
        end
      end,
    })
    
    -- Colorschemes
    pcall(require('tokyonight').setup, {
      style = 'storm',
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        sidebars = 'dark',
        floats = 'dark',
      },
    })
    
    pcall(require('github-theme').setup, {
      options = {
        transparent = true,
      },
    })
    
    pcall(require('catppuccin').setup, {
      flavour = 'mocha',
      transparent_background = false,
    })
    
    -- Cloak
    pcall(require('cloak').setup, {
      enabled = false,
      cloak_character = '*',
      highlight_group = 'Comment',
      patterns = {
        {
          file_pattern = { '.env*', 'wrangler.toml', '.dev.vars' },
          cloak_pattern = '=.+',
        },
      },
    })
    
    -- Barbar
    pcall(require('barbar').setup, {})
    
    -- Copilot
    pcall(require('copilot').setup, {
      copilot_model = 'gpt-4.1-copilot',
      suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = false,
        debounce = 25,
        keymap = {
          accept = false,
          accept_word = false,
          accept_line = '<S-Tab>',
          next = false,
          prev = false,
          dismiss = false,
        },
      },
      telemetryLevel = 'none',
    })
    
    -- Copilot lualine component
    pcall(require, 'copilot-lualine')
    
    -- Crates
    pcall(require('crates').setup, {})
    
    -- Nvim-tree
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.termguicolors = true
    pcall(require('nvim-tree').setup, {
      sort = { sorter = 'case_sensitive' },
      view = { width = 30 },
      renderer = { group_empty = true },
      filters = { dotfiles = true },
    })
    vim.keymap.set('n', '<leader><C>T', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    
    -- Lualine
    pcall(require('lualine').setup, {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'copilot', 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
    })
    
    -- Telescope
    pcall(require('telescope').setup, {})
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>pf', builtin.find_files)
    vim.keymap.set('n', '<C-p>', builtin.git_files)
    vim.keymap.set('n', '<leader>pws', function()
      local word = vim.fn.expand('<cword>')
      builtin.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>pWs', function()
      local word = vim.fn.expand('<cWORD>')
      builtin.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>ps', function()
      builtin.grep_string({ search = vim.fn.input('Grep > ') })
    end)
    vim.keymap.set('n', '<leader>vh', builtin.help_tags)
    
    -- Harpoon
    pcall(function()
      local harpoon = require('harpoon')
      harpoon.setup()
      vim.keymap.set('n', '<leader>A', function() harpoon:list():prepend() end)
      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)
      vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set('n', '<C-h>', function() harpoon:list():select(1) end)
      vim.keymap.set('n', '<C-t>', function() harpoon:list():select(2) end)
      vim.keymap.set('n', '<C-n>', function() harpoon:list():select(3) end)
      vim.keymap.set('n', '<C-s>', function() harpoon:list():select(4) end)
      vim.keymap.set('n', '<leader><C-h>', function() harpoon:list():replace_at(1) end)
      vim.keymap.set('n', '<leader><C-t>', function() harpoon:list():replace_at(2) end)
      vim.keymap.set('n', '<leader><C-n>', function() harpoon:list():replace_at(3) end)
      vim.keymap.set('n', '<leader><C-s>', function() harpoon:list():replace_at(4) end)
    end)
    
    -- Fugitive
    pcall(function()
      vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
      local group = vim.api.nvim_create_augroup('ThePrimeagen_Fugitive', {})
      autocmd('BufWinEnter', {
        group = group,
        pattern = '*',
        callback = function()
          if vim.bo.ft ~= 'fugitive' then
            return
          end
          local bufnr = vim.api.nvim_get_current_buf()
          local opts = { buffer = bufnr, remap = false }
          vim.keymap.set('n', '<leader>p', function()
            vim.cmd.Git('push')
          end, opts)
          vim.keymap.set('n', '<leader>P', function()
            vim.cmd.Git({ 'pull', '--rebase' })
          end, opts)
          vim.keymap.set('n', '<leader>t', ':Git push -u origin ', opts)
        end,
      })
      vim.keymap.set('n', 'gu', '<cmd>diffget //2<CR>')
      vim.keymap.set('n', 'gh', '<cmd>diffget //3<CR>')
    end)
    
    -- Litee + gh.nvim
    pcall(require('litee.lib').setup, {})
    pcall(require('litee.gh').setup, {})
    
    -- GP.nvim
    pcall(require('gp').setup, {
      providers = {
        openai = {
          disable = false,
          endpoint = 'https://api.openai.com/v1/chat/completions',
          secret = { 'cat', '/home/shane/.openai/.gp.nvim.key' },
        },
        copilot = {
          disable = true,
          endpoint = 'https://api.githubcopilot.com/chat/completions',
          secret = {
            'bash',
            '-c',
            "cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'",
          },
        },
        ollama = {
          disable = true,
          endpoint = 'http://localhost:11432/v1/chat/completions',
        },
        anthropic = {
          disable = true,
          endpoint = 'https://api.anthropic.com/v-1/messages',
          secret = os.getenv('ANTHROPIC_API_KEY'),
        },
      },
      agents = {
        {
          provider = 'openai',
          name = 'ChatGPT4.1',
          chat = true,
          command = false,
          model = {
            model = 'gpt-4.1',
            temperature = 0.0,
            max_tokens = 32768,
            top_p = 0,
          },
          system_prompt = require('gp.defaults').chat_system_prompt,
        },
        {
          provider = 'openai',
          name = 'ChatGPT5',
          chat = true,
          command = false,
          model = {
            model = 'gpt-5',
            reasoning_effort = 'high',
            verbosity = 'high',
            summary = 'detailed',
          },
          system_prompt = require('gp.defaults').code_system_prompt,
        },
        {
          provider = 'openai',
          name = 'CodeGPT4.1',
          chat = false,
          command = true,
          model = {
            model = 'gpt-4.1',
            temperature = 0.0,
            max_tokens = 32768,
            top_p = 0,
          },
          system_prompt = require('gp.defaults').code_system_prompt,
        },
        {
          provider = 'openai',
          name = 'CodeGPT5',
          chat = false,
          command = true,
          model = {
            model = 'gpt-5-codex',
            reasoning_effort = 'high',
            verbosity = 'high',
          },
          system_prompt = require('gp.defaults').code_system_prompt,
        },
      },
    })
    
    -- IDAScope
    pcall(function()
      local telescope = require('telescope')
      telescope.setup({
        defaults = {
          preview = { scroll_strategy = 'cycle' },
        },
      })
      local ida_plugin = require('telescope_ida')
      local ida_plugins_dir = string.format('%s/.idapro/plugins', vim.loop.os_homedir())
      vim.fn.mkdir(ida_plugins_dir, 'p')
      ida_plugin.setup({
        server_url = 'http://localhost:65432/',
        default_extension = '.c',
        verbose = false,
        ida_plugins_dir = ida_plugins_dir,
        check_if_installed = false,
      })
      vim.api.nvim_create_user_command('IDAScope', function(args)
        local xml_url = (args.args ~= "") and args.args or ida_plugin.ida_xml_server
        ida_plugin.IDAScope(xml_url)
      end, { nargs = '?', desc = 'IDAScope' })
      vim.keymap.set('n', '<leader>vv', function()
        ida_plugin.IDAScope()
      end, { desc = 'Open IDAScope with Telescope' })
    end)
    
    -- LuaSnip shortcuts and friendly snippets
    pcall(function()
      local ls = require('luasnip')
      ls.filetype_extend('javascript', { 'jsdoc' })
      vim.keymap.set({ 'i' }, '<C-s>e', function() ls.expand() end, { silent = true })
      vim.keymap.set({ 'i', 's' }, '<C-s>;', function() ls.jump(1) end, { silent = true })
      vim.keymap.set({ 'i', 's' }, '<C-s>,', function() ls.jump(-1) end, { silent = true })
      vim.keymap.set({ 'i', 's' }, '<C-E>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })
    end)
    
    -- Nvim-dap, dap-ui, mason-nvim-dap
    pcall(function()
      vim.api.nvim_create_augroup('DapGroup', { clear = true })
      local function navigate(args)
        local buffer = args.buf
        local wid
        for _, win_id in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win_id) == buffer then
            wid = win_id
            break
          end
        end
        if not wid then
          return
        end
        vim.schedule(function()
          if vim.api.nvim_win_is_valid(wid) then
            vim.api.nvim_set_current_win(wid)
          end
        end)
      end
    
      local function create_nav_options(name)
        return {
          group = 'DapGroup',
          pattern = string.format('*%s*', name),
          callback = navigate,
        }
      end
    
      local dap = require('dap')
      dap.set_log_level('DEBUG')
      vim.keymap.set('n', '<leader><F6>', dap.continue, { desc = 'Debug: Continue' })
      vim.keymap.set('n', '<leader><F8>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<leader><F7>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<leader><F5>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, { desc = 'Debug: Set Conditional Breakpoint' })
    
      local dapui = require('dapui')
      local function layout(name)
        return {
          elements = { { id = name } },
          enter = true,
          size = 40,
          position = 'right',
        }
      end
      local name_to_layout = {
        repl = { layout = layout('repl'), index = 0 },
        stacks = { layout = layout('stacks'), index = 0 },
        scopes = { layout = layout('scopes'), index = 0 },
        console = { layout = layout('console'), index = 0 },
        watches = { layout = layout('watches'), index = 0 },
        breakpoints = { layout = layout('breakpoints'), index = 0 },
      }
      local layouts = {}
      for name, cfg in pairs(name_to_layout) do
        table.insert(layouts, cfg.layout)
        name_to_layout[name].index = #layouts
      end
      local function toggle_debug_ui(name)
        dapui.close()
        local layout_config = name_to_layout[name]
        if not layout_config then
          error(string.format('bad name: %s', name))
        end
        local uis = vim.api.nvim_list_uis()[1]
        if uis then
          layout_config.size = uis.width
        end
        pcall(dapui.toggle, layout_config.index)
      end
      vim.keymap.set('n', '<leader>dr', function() toggle_debug_ui('repl') end, { desc = 'Debug: toggle repl ui' })
      vim.keymap.set('n', '<leader>ds', function() toggle_debug_ui('stacks') end, { desc = 'Debug: toggle stacks ui' })
      vim.keymap.set('n', '<leader>dw', function() toggle_debug_ui('watches') end, { desc = 'Debug: toggle watches ui' })
      vim.keymap.set('n', '<leader>db', function() toggle_debug_ui('breakpoints') end, { desc = 'Debug: toggle breakpoints ui' })
      vim.keymap.set('n', '<leader>dS', function() toggle_debug_ui('scopes') end, { desc = 'Debug: toggle scopes ui' })
      vim.keymap.set('n', '<leader>dc', function() toggle_debug_ui('console') end, { desc = 'Debug: toggle console ui' })
    
      autocmd('BufEnter', {
        group = 'DapGroup',
        pattern = '*dap-repl*',
        callback = function()
          vim.wo.wrap = true
        end,
      })
      autocmd('BufWinEnter', create_nav_options('dap-repl'))
      autocmd('BufWinEnter', create_nav_options('DAP Watches'))
    
      dapui.setup({ layouts = layouts, enter = true })
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      dap.listeners.after.event_output.dapui_config = function(_, body)
        if body.category == 'console' then
          dapui.eval(body.output)
        end
      end
    
      require('mason-nvim-dap').setup({
        ensure_installed = {},
        automatic_installation = false,
      })

      dap.adapters.go = {
        type = 'server',
        host = '127.0.0.1',
        port = 38697,
        executable = {
          command = 'dlv',
          args = { 'dap', '-l', '127.0.0.1:38697' },
        },
      }

      local function go_args()
        local input = vim.fn.input('args> ')
        if input == "" then
          return {}
        end
        return vim.split(input, ' ')
      end

      local function dap_program_file()
        return '$' .. '{' .. 'file' .. '}'
      end

      dap.configurations.go = {
        {
          type = 'go',
          name = 'file',
          request = 'launch',
          program = dap_program_file(),
          args = go_args,
        },
        {
          type = 'go',
          name = 'file args',
          request = 'launch',
          program = dap_program_file(),
          args = go_args,
        },
      }
    end)
    
    -- Mason / LSP / Conform / CMP setup
    pcall(function()
      require('conform').setup({
        formatters_by_ft = {
          c = { 'clang-format' },
          cpp = { 'clang-format' },
          h = { 'clang-format' },
          hpp = { 'clang-format' },
        },
        linters_by_ft = {
          c = { 'cpplint' },
          cpp = { 'cpplint' },
          h = { 'cpplint' },
          hpp = { 'cpplint' },
        },
        linters = {
          cpplint = {
            command = 'cpplint',
          },
        },
      })
      local cmp = require('cmp')
      local cmp_lsp = require('cmp_nvim_lsp')
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities()
      )
      require('fidget').setup({})
      vim.lsp.config('ts_ls', {
        init_options = {
          preferences = {
            includeInlayParameterNameHints = 'all',
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      })
      require('mason').setup({
        PATH = 'skip',
      })
      require('mason-lspconfig').setup({
        ensure_installed = {},
        automatic_installation = false,
      })
      local lspconfig = require('lspconfig')
      local servers = {
        'lua_ls',
        'rust_analyzer',
        'gopls',
        'ts_ls',
        'biome',
        'csharp_ls',
        'nixd',
      }
      for _, server in ipairs(servers) do
        lspconfig[server].setup({
          capabilities = capabilities,
        })
      end
      local cmp_select = { behavior = cmp.SelectBehavior.Select }
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = 'copilot', group_index = 2 },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        }),
      })
    end)
    
    -- Mason + nvim-lint integration
    pcall(function()
      local lint = require('lint')
      local severities = {
        note = vim.diagnostic.severity.INFO,
        warning = vim.diagnostic.severity.WARN,
        help = vim.diagnostic.severity.HINT,
        error = vim.diagnostic.severity.ERROR,
      }
      local function parse_clippy(diagnostics, file_name, item)
        for _, span in ipairs(item.spans or {}) do
          if span.file_name == file_name then
            local message = item.message
            if span.suggested_replacement ~= vim.NIL then
              message = message .. '\nSuggested replacement:\n\n' .. tostring(span.suggested_replacement)
            end
            table.insert(diagnostics, {
              lnum = (span.line_start or 1) - 1,
              end_lnum = (span.line_end or span.line_start or 1) - 1,
              col = (span.column_start or 1) - 1,
              end_col = (span.column_end or span.column_start or 1) - 1,
              severity = severities[item.level] or vim.diagnostic.severity.ERROR,
              source = 'clippy',
              message = message,
            })
          end
        end
        for _, child in ipairs(item.children or {}) do
          parse_clippy(diagnostics, file_name, child)
        end
      end
      lint.linters.clippy = {
        cmd = 'cargo',
        args = { 'clippy', '--message-format=json' },
        stdin = false,
        append_fname = false,
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local diagnostics = {}
          local items = #output > 0 and vim.split(output, '\n') or {}
          local file_name = vim.api.nvim_buf_get_name(bufnr)
          file_name = vim.fn.fnamemodify(file_name, ':.')
          for _, i in ipairs(items) do
            local item = i ~= "" and vim.json.decode(i) or {}
            if item and item.reason == 'compiler-message' then
              parse_clippy(diagnostics, file_name, item.message)
            end
          end
          return diagnostics
        end,
      }
      lint.linters.cppcheck.args = {
        '--enable=warning,style,performance,information',
        function()
          if vim.bo.filetype == 'cpp' then
            return '--language=c++'
          else
            return '--language=c'
          end
        end,
        '--inline-suppr',
        '--quiet',
        function()
          if vim.fn.isdirectory('build') == 1 then
            return '--cppcheck-build-dir=build'
          end
          return nil
        end,
        function()
          if vim.fn.filereadable('.cppcheck-suppress') == 1 then
            return '--suppressions-list=.cppcheck-suppress'
          end
          return nil
        end,
        '--template={file}:{line}:{column}: [{id}] {severity}: {message}',
      }
      local biome = lint.linters.biomejs
      lint.linters.biomejs = function()
        biome.args = { 'lint', '--reporter=github' }
        biome.parser = function(output, bufnr, linter_cwd)
          local reporterGithubParser = require('lint.parser').from_pattern(
            '::(.+) title=(.+),file=(.+),line=(%d+),endLine=(%d+),col=(%d+),endColumn=(%d+)::(.+)',
            { 'severity', 'code', 'file', 'lnum', 'end_lnum', 'col', 'end_col', 'message' },
            {
              error = vim.diagnostic.severity.ERROR,
              warning = vim.diagnostic.severity.WARN,
              notice = vim.diagnostic.severity.INFO,
            },
            { source = 'biomejs' },
            { lnum_offset = 0, end_lnum_offset = 0, end_col_offset = -1 }
          )
          local parseErrorParser = function(err_output)
            local diagnostics = {}
            local fetch_message = false
            local lnum, col, code, message
            for _, line in ipairs(vim.fn.split(err_output, '\n')) do
              if fetch_message then
                _, _, message = string.find(line, '%s×(.+)')
                if message then
                  message = (message):gsub('^%s+×%s*', "")
                  table.insert(diagnostics, {
                    source = 'biomejs',
                    lnum = tonumber(lnum) - 1,
                    col = tonumber(col),
                    message = message,
                    code = code,
                  })
                  fetch_message = false
                end
              else
                _, _, lnum, col, code = string.find(line, '[^:]+:(%d+):(%d+)%s([%a%/]+)')
                if lnum then
                  fetch_message = true
                end
              end
            end
            return diagnostics
          end
          local result = reporterGithubParser(output, bufnr, linter_cwd)
          if #result ~= 0 then
            return result
          end
          return parseErrorParser(output)
        end
        return biome
      end
      lint.linters_by_ft = {
        make = { 'checkmake' },
        rust = { 'clippy' },
        cpp = { 'cppcheck' },
        c = { 'cppcheck' },
        javascript = { 'biomejs' },
        typescript = { 'biomejs' },
        javascriptreact = { 'biomejs' },
        typescriptreact = { 'biomejs' },
      }
      autocmd({ 'InsertLeave', 'BufReadPost', 'BufNewFile' }, {
        callback = function()
          lint.try_lint()
        end,
      })
      require('mason-nvim-lint').setup({
        ensure_installed = {},
        automatic_installation = false,
      })
    end)
    
    -- Treesitter & context
    pcall(function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {},
        sync_install = false,
        auto_install = false,
        indent = { enable = true },
        highlight = {
          enable = true,
          disable = function(_, buf)
            local max_filesize = 100 * 1024
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              vim.notify('File larger than 100KB treesitter disabled for performance', vim.log.levels.WARN, { title = 'Treesitter' })
              return true
            end
          end,
          additional_vim_regex_highlighting = { 'markdown' },
        },
      })
      local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
      parser_config.templ = {
        install_info = {
          url = 'https://github.com/vrischmann/tree-sitter-templ.git',
          files = { 'src/parser.c', 'src/scanner.c' },
          branch = 'master',
        },
      }
      vim.treesitter.language.register('templ', 'templ')
      require('treesitter-context').setup({
        enable = true,
        multiwindow = false,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = 'outer',
        mode = 'cursor',
        separator = nil,
        zindex = 20,
      })
    end)
    
    -- Rainbow delimiters
    pcall(require('rainbow-delimiters.setup').setup, {
      strategy = {
        [""] = 'rainbow-delimiters.strategy.global',
        vim = 'rainbow-delimiters.strategy.local',
      },
      query = {
        [""] = 'rainbow-delimiters',
        lua = 'rainbow-blocks',
        python = 'rainbow-blocks',
      },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
    })
    
    -- Render Markdown
    pcall(require('render-markdown').setup, {})
    
    -- Reticle
    pcall(require('reticle').setup, {
      on_startup = {
        cursorline = true,
        cursorcolumn = true,
      },
    })
    
    -- Peek
    pcall(function()
      local peek = require('peek')
      peek.setup({ filetype = { 'markdown', 'conf' } })
      vim.api.nvim_create_user_command('PeekOpen', peek.open, {})
      vim.api.nvim_create_user_command('PeekClose', peek.close, {})
    end)
    
    -- Yazi
    pcall(function()
      vim.g.loaded_netrwPlugin = 1
      vim.keymap.set({ 'n', 'v' }, '<leader>-', '<cmd>Yazi<cr>', { desc = 'Open yazi at current file' })
      vim.keymap.set('n', '<leader>cw', '<cmd>Yazi cwd<cr>', { desc = "Open yazi in cwd" })
      vim.keymap.set('n', '<C-Up>', '<cmd>Yazi toggle<cr>', { desc = 'Resume last yazi session' })
    end)
    
    -- Trouble
    pcall(function()
      require('trouble').setup({ icons = false })
      vim.keymap.set('n', '<leader>tt', function() require('trouble').toggle() end)
      vim.keymap.set('n', '[t', function() require('trouble').next({ skip_groups = true, jump = true }) end)
      vim.keymap.set('n', ']t', function() require('trouble').previous({ skip_groups = true, jump = true }) end)
    end)
    
    -- Twilight
    pcall(function()
      require('twilight').setup({
        dimming = {
          alpha = 0.25,
          color = { 'Normal', '#ffffff' },
          term_bg = '#000000',
          inactive = false,
        },
        context = 0,
        treesitter = true,
        expand = { '_declaration', '_definition', '_statement', '_constructor' },
        exclude = {},
      })
      vim.keymap.set('n', '<leader>T', function() require('twilight').toggle() end, { desc = 'Toggle Twilight' })
      vim.keymap.set('n', '<leader>E', function() require('twilight').enable() end, { desc = 'Enable Twilight' })
      vim.keymap.set('n', '<leader>D', function() require('twilight').disable() end, { desc = 'Disable Twilight' })
    end)
    
    -- Zen mode
    pcall(function()
      vim.keymap.set('n', '<leader>zz', function()
        require('zen-mode').setup({ window = { width = 90, options = {} } })
        require('zen-mode').toggle()
        vim.wo.wrap = false
        vim.wo.number = true
        vim.wo.rnu = true
        ColorMyPencils()
      end)
      vim.keymap.set('n', '<leader>zZ', function()
        require('zen-mode').setup({ window = { width = 80, options = {} } })
        require('zen-mode').toggle()
        vim.wo.wrap = false
        vim.wo.number = false
        vim.wo.rnu = false
        vim.opt.colorcolumn = '0'
        ColorMyPencils()
      end)
    end)
    
    -- Which-key helper binding
    pcall(require('which-key').setup, {})
    vim.keymap.set('n', '<leader>?', function()
      require('which-key').show({ global = false })
    end, { desc = 'Buffer Local Keymaps (which-key)' })
    
    -- Neogit & Diffview
    pcall(require('neogit').setup, {})
    
    -- Neoscroll
    pcall(require('neoscroll').setup, {})
    
    -- Undotree shortcut handled via keymaps but ensure plugin loaded
    vim.cmd.runtime('plugin/undotree.vim')
    
    -- Vim-be-good is loaded on demand
    
    -- Snacks
    pcall(function()
      require('snacks').setup({
        input = {},
        picker = {},
        terminal = {},
      })
    end)

    -- Opencode / Snacks
    pcall(function()
      vim.g.opencode_opts = {
        port = 4001,
        provider = {
          cmd = 'opencode --port 4001',
          enabled = 'snacks',
        },
      }
      vim.o.autoread = true
      vim.keymap.set({ 'n', 'x' }, '<C-a>', function() require('opencode').ask('@this: ', { submit = true }) end, { desc = 'Ask opencode' })
      vim.keymap.set({ 'n', 'x' }, '<C-x>', function() require('opencode').select() end, { desc = 'Execute opencode action…' })
      vim.keymap.set({ 'n', 'x' }, 'ga', function() require('opencode').prompt('@this') end, { desc = 'Add to opencode' })
      vim.keymap.set({ 'n', 't' }, '<C-.>', function() require('opencode').toggle() end, { desc = 'Toggle opencode' })
      vim.keymap.set('n', '<S-C-u>', function() require('opencode').command('session.half.page.up') end, { desc = 'opencode half page up' })
      vim.keymap.set('n', '<S-C-d>', function() require('opencode').command('session.half.page.down') end, { desc = 'opencode half page down' })
      vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment', noremap = true })
      vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement', noremap = true })
    end)
    
    -- Render markdown dependency mini already setup via plugin list
    -- Peek commands defined earlier
    
    -- Crates already configured
    -- Snacks is configured via dependency defaults
    
    -- Neotest
    pcall(function()
      local neotest = require('neotest')
      neotest.setup({
        adapters = {
          require('neotest-golang')({ dap = { justMyCode = false } }),
          require('neotest-rust')({ args = { '--no-capture' } }),
        },
      })
      vim.keymap.set('n', '<leader>tr', function()
        neotest.run.run({ suite = false, testify = true })
      end, { desc = 'Debug: Running Nearest Test' })
      vim.keymap.set('n', '<leader>tv', function()
        neotest.summary.toggle()
      end, { desc = 'Debug: Summary Toggle' })
      vim.keymap.set('n', '<leader>ts', function()
        neotest.run.run({ suite = true, testify = true })
      end, { desc = 'Debug: Running Test Suite' })
      vim.keymap.set('n', '<leader>td', function()
        neotest.run.run({ suite = false, testify = true, strategy = 'dap' })
      end, { desc = 'Debug: Debug Nearest Test' })
      vim.keymap.set('n', '<leader>to', function()
        neotest.output.open()
      end, { desc = 'Debug: Open test output' })
      vim.keymap.set('n', '<leader>ta', function()
        neotest.run.run(vim.fn.getcwd())
      end, { desc = 'Debug: Run all tests in workspace' })
    end)
    
    -- Peek commands already defined
    -- Render markdown already setup
    
    -- Telescope dependent plugins (idascope) already configured
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
      grammarPackages = [
        (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
          p.vimdoc
          p.javascript
          p.typescript
          p.c
          p.lua
          p.rust
          p.jsdoc
          p.bash
        ]))
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
      ];

    extraConfigLuaPost = luaConfig;
  };

  xdg.dataFile = masonDataFiles;
}
