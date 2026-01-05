local M = {}

function M.setup()
  pcall(require('copilot').setup, {
    copilot_model = 'gpt-4.1-copilot',
    suggestion = {
      enabled = true,
      auto_trigger = false,
      hide_during_completion = false,
      debounce = 25,
      keymap = {
        accept = false,
        accept_word = false,
        accept_line = '<S-Tab>',
        next = false,
        prev = false,
        dismiss = false,
      },
    },
    telemetryLevel = 'none',
  })

  pcall(require, 'copilot-lualine')
end

return M
