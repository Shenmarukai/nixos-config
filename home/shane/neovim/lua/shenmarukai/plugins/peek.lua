local M = {}

function M.setup()
  pcall(function()
    local peek = require('peek')
    peek.setup({ filetype = { 'markdown', 'conf' } })
    vim.api.nvim_create_user_command('PeekOpen', peek.open, {})
    vim.api.nvim_create_user_command('PeekClose', peek.close, {})
  end)
end

return M
