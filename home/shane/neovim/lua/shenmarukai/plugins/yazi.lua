local M = {}

function M.setup()
  pcall(function()
    vim.g.loaded_netrwPlugin = 1
    vim.keymap.set({ 'n', 'v' }, '<leader>-', '<cmd>Yazi<cr>', { desc = 'Open yazi at current file' })
    vim.keymap.set('n', '<leader>cw', '<cmd>Yazi cwd<cr>', { desc = 'Open yazi in cwd' })
    vim.keymap.set('n', '<C-Up>', '<cmd>Yazi toggle<cr>', { desc = 'Resume last yazi session' })
  end)
end

return M
