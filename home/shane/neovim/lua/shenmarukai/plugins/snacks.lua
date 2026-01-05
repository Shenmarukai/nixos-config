local M = {}

function M.setup()
  pcall(function()
    require('snacks').setup({
      input = {},
      picker = {},
      terminal = {},
    })
  end)
end

return M
