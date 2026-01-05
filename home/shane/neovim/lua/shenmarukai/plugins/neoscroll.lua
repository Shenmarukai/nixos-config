local M = {}

function M.setup()
  pcall(require('neoscroll').setup, {})
end

return M
