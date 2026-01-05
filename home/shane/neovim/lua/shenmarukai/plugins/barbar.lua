local M = {}

function M.setup()
  pcall(require('barbar').setup, {})
end

return M
