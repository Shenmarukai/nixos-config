local M = {}

function M.setup()
  pcall(require('neogit').setup, {})
end

return M
