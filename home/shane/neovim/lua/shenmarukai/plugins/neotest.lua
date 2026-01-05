local M = {}

function M.setup()
  pcall(function()
    local neotest = require('neotest')
    neotest.setup({
      adapters = {
        require('neotest-golang')({ dap = { justMyCode = false } }),
        require('neotest-rust')({ args = { '--no-capture' } }),
      },
    })
    vim.keymap.set('n', '<leader>tr', function()
      neotest.run.run({ suite = false, testify = true })
    end, { desc = 'Debug: Running Nearest Test' })
    vim.keymap.set('n', '<leader>tv', function()
      neotest.summary.toggle()
    end, { desc = 'Debug: Summary Toggle' })
    vim.keymap.set('n', '<leader>ts', function()
      neotest.run.run({ suite = true, testify = true })
    end, { desc = 'Debug: Running Test Suite' })
    vim.keymap.set('n', '<leader>td', function()
      neotest.run.run({ suite = false, testify = true, strategy = 'dap' })
    end, { desc = 'Debug: Debug Nearest Test' })
    vim.keymap.set('n', '<leader>to', function()
      neotest.output.open()
    end, { desc = 'Debug: Open test output' })
    vim.keymap.set('n', '<leader>ta', function()
      neotest.run.run(vim.fn.getcwd())
    end, { desc = 'Debug: Run all tests in workspace' })
  end)
end

return M
