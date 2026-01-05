local M = {}

function M.setup()
  pcall(function()
    vim.api.nvim_create_augroup('DapGroup', { clear = true })
    local function navigate(args)
      local buffer = args.buf
      local wid
      for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win_id) == buffer then
          wid = win_id
          break
        end
      end
      if not wid then
        return
      end
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(wid) then
          vim.api.nvim_set_current_win(wid)
        end
      end)
    end

    local function create_nav_options(name)
      return {
        group = 'DapGroup',
        pattern = string.format('*%s*', name),
        callback = navigate,
      }
    end

    local dap = require('dap')
    dap.set_log_level('DEBUG')
    vim.keymap.set('n', '<leader><F6>', dap.continue, { desc = 'Debug: Continue' })
    vim.keymap.set('n', '<leader><F8>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<leader><F7>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<leader><F5>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, { desc = 'Debug: Set Conditional Breakpoint' })

    local dapui = require('dapui')
    local function layout(name)
      return {
        elements = { { id = name } },
        enter = true,
        size = 40,
        position = 'right',
      }
    end

    local name_to_layout = {
      repl = { layout = layout('repl'), index = 0 },
      stacks = { layout = layout('stacks'), index = 0 },
      scopes = { layout = layout('scopes'), index = 0 },
      console = { layout = layout('console'), index = 0 },
      watches = { layout = layout('watches'), index = 0 },
      breakpoints = { layout = layout('breakpoints'), index = 0 },
    }
    local layouts = {}
    for name, cfg in pairs(name_to_layout) do
      table.insert(layouts, cfg.layout)
      name_to_layout[name].index = #layouts
    end
    local function toggle_debug_ui(name)
      dapui.close()
      local layout_config = name_to_layout[name]
      if not layout_config then
        error(string.format('bad name: %s', name))
      end
      local uis = vim.api.nvim_list_uis()[1]
      if uis then
        layout_config.size = uis.width
      end
      pcall(dapui.toggle, layout_config.index)
    end
    vim.keymap.set('n', '<leader>dr', function() toggle_debug_ui('repl') end, { desc = 'Debug: toggle repl ui' })
    vim.keymap.set('n', '<leader>ds', function() toggle_debug_ui('stacks') end, { desc = 'Debug: toggle stacks ui' })
    vim.keymap.set('n', '<leader>dw', function() toggle_debug_ui('watches') end, { desc = 'Debug: toggle watches ui' })
    vim.keymap.set('n', '<leader>db', function() toggle_debug_ui('breakpoints') end, { desc = 'Debug: toggle breakpoints ui' })
    vim.keymap.set('n', '<leader>dS', function() toggle_debug_ui('scopes') end, { desc = 'Debug: toggle scopes ui' })
    vim.keymap.set('n', '<leader>dc', function() toggle_debug_ui('console') end, { desc = 'Debug: toggle console ui' })

    vim.api.nvim_create_autocmd('BufEnter', {
      group = 'DapGroup',
      pattern = '*dap-repl*',
      callback = function()
        vim.wo.wrap = true
      end,
    })
    vim.api.nvim_create_autocmd('BufWinEnter', create_nav_options('dap-repl'))
    vim.api.nvim_create_autocmd('BufWinEnter', create_nav_options('DAP Watches'))

    dapui.setup({ layouts = layouts, enter = true })
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
    dap.listeners.after.event_output.dapui_config = function(_, body)
      if body.category == 'console' then
        dapui.eval(body.output)
      end
    end

    require('mason-nvim-dap').setup({
      ensure_installed = {},
      automatic_installation = false,
    })

    dap.adapters.go = {
      type = 'server',
      host = '127.0.0.1',
      port = 38697,
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:38697' },
      },
    }

    local function go_args()
      local input = vim.fn.input('args> ')
      if input == "" then
        return {}
      end
      return vim.split(input, ' ')
    end

    local function dap_program_file()
      return '${file}'
    end

    dap.configurations.go = {
      {
        type = 'go',
        name = 'file',
        request = 'launch',
        program = dap_program_file(),
        args = go_args,
      },
      {
        type = 'go',
        name = 'file args',
        request = 'launch',
        program = dap_program_file(),
        args = go_args,
      },
    }
  end)
end

return M
