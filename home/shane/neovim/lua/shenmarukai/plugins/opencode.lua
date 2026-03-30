local M = {}

function M.setup()
  pcall(function()
    local opencode_cmd = "opencode --port"

    local snacks_terminal_opts = {
      win = {
        position = "right",
        enter = false,
        on_win = function(win)
          require("opencode.terminal").setup(win.win)
        end,
      },
    }

    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(opencode_cmd, snacks_terminal_opts)
        end,
        stop = function()
          local term = require("snacks.terminal").get(opencode_cmd, snacks_terminal_opts)
          if term then term:close() end
        end,
        toggle = function()
          require("snacks.terminal").toggle(opencode_cmd, snacks_terminal_opts)
        end,
      },
    }

    vim.o.autoread = true

    vim.keymap.set({ "n", "x" }, "<C-a>", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode" })

    vim.keymap.set({ "n", "x" }, "<C-x>", function()
      require("opencode").select()
    end, { desc = "Execute opencode action…" })

    vim.keymap.set({ "n", "x" }, "ga", function()
      require("opencode").prompt("@this")
    end, { desc = "Add to opencode" })

    vim.keymap.set({ "n", "t" }, "<C-.>", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })

    vim.keymap.set("n", "<leader>os", function()
      require("opencode").select_server()
    end, { desc = "Select opencode server" })
  end)
end

return M
