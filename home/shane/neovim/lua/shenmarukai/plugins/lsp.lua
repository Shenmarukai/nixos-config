local M = {}

function M.setup()
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

    require('mason').setup({
      PATH = 'skip',
    })

    require('mason-lspconfig').setup({
      ensure_installed = {},
      automatic_enable = false,
    })

    local servers = {
      'lua_ls',
      'rust_analyzer',
      'gopls',
      'ts_ls',
      'biome',
      'clangd',
      'csharp_ls',
      'nixd',
      'nil_ls',
    }

    local server_configs = {
      ts_ls = {
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
      },

      rust_analyzer = {
        cmd = { vim.fn.exepath('rust-analyzer') },
      },

      clangd = {
        cmd = {
          vim.fn.exepath('clangd'),
          '--enable-config',
          '--background-index',
        },
      },

      nil_ls = {
        cmd = { vim.fn.exepath('nil') },
        filetypes = { 'nix' },

        on_attach = function(client, bufnr)
          if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end

          client.server_capabilities.inlayHintProvider = true
          client.server_capabilities.publishDiagnosticsProvider = true
        end,

        settings = {
          ['nil'] = {
            formatting = {
              command = nil,
              -- Change to { "nixfmt" } if installed.
            },
            diagnostics = {
              ignored = {},
              excludedFiles = {},
            },
            inlay = {
              hints = true,
            },
            nix = {
              binary = 'nix',
              maxMemoryMB = 32768,
              flake = {
                autoArchive = nil,
                autoEvalInputs = true,
                nixpkgsInputName = 'nixpkgs',
              },
            },
          },
        },
      },
    }

    for _, server in ipairs(servers) do
      local server_config = server_configs[server] or {}

      server_config = vim.tbl_deep_extend('force', {
        capabilities = capabilities,
      }, server_config)

      vim.lsp.config(server, server_config)
      vim.lsp.enable(server)
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
end

return M
