local M = {}

function M.setup()
  pcall(require('cloak').setup, {
    enabled = false,
    cloak_character = '*',
    highlight_group = 'Comment',
    patterns = {
      {
        file_pattern = { '.env*', 'wrangler.toml', '.dev.vars' },
        cloak_pattern = '=.+',
      },
    },
  })
end

return M
