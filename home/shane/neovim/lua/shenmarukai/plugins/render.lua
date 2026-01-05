local M = {}

function M.setup()
  pcall(require('render-markdown').setup, {})
end

return M
