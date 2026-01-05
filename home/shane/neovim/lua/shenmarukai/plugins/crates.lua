local M = {}

function M.setup()
  pcall(require('crates').setup, {})
end

return M
