local M = {}

function M.setup()
  pcall(require('reticle').setup, {
    on_startup = {
      cursorline = true,
      cursorcolumn = true,
    },
  })
end

return M
