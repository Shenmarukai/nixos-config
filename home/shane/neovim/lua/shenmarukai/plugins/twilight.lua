local M = {}

function M.setup()
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
end

return M
