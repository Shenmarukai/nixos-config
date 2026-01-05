local M = {}

function M.setup()
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
end

return M
