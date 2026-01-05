local M = {}

function M.setup()
  pcall(require('litee.lib').setup, {})
  pcall(require('litee.gh').setup, {})
end

return M
