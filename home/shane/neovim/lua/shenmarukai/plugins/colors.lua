local M = {}

function M.setup()
  pcall(require('tokyonight').setup, {
    style = 'storm',
    transparent = true,
    terminal_colors = true,
    styles = {
      comments = { italic = false },
      keywords = { italic = false },
      sidebars = 'dark',
      floats = 'dark',
    },
  })

  pcall(require('github-theme').setup, {
    options = {
      transparent = true,
    },
  })

  pcall(require('catppuccin').setup, {
    flavour = 'mocha',
    transparent_background = false,
  })
end

return M
