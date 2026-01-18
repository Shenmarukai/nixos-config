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
      automatic_enable = false,
    })
    local lspconfig = require('lspconfig')
    local servers = {
      'lua_ls',
      'rust_analyzer',
      'gopls',
      'ts_ls',
      'biome',
      'clangd',
      'csharp_ls',
      'nixd',
    }
    local server_configs = {
      rust_analyzer = {
        cmd = { vim.fn.exepath('rust-analyzer') },
      },
      clangd = {
        cmd = (function()
          local mason_clangd = vim.fn.stdpath('data') .. '/mason/bin/clangd'
          local clangd_path = mason_clangd
          if vim.fn.executable(clangd_path) ~= 1 then
            clangd_path = vim.fn.exepath('clangd')
          end

          return {
            clangd_path,
            '--enable-config',
            '--background-index',
            '--clang-tidy',
            '--query-driver=**/clang++,**/g++,**/gcc,**/i686-w64-mingw32-g++,**/i686-w64-mingw32-gcc',
          }
        end)(),
      },
    }
    for _, server in ipairs(servers) do
      local server_config = server_configs[server] or {}
      server_config.capabilities = capabilities
      lspconfig[server].setup(server_config)
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
