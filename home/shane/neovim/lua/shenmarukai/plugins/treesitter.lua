local M = {}

function M.setup()
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
end

return M
