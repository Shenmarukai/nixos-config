local M = {}

function M.setup()
  pcall(function()
    local telescope = require('telescope')
    telescope.setup({
      defaults = {
        preview = { scroll_strategy = 'cycle' },
      },
    })
    local ida_plugin = require('telescope_ida')
    local ida_plugins_dir = string.format('%s/.idapro/plugins', vim.loop.os_homedir())
    vim.fn.mkdir(ida_plugins_dir, 'p')
    ida_plugin.setup({
      server_url = 'http://localhost:65432/',
      default_extension = '.c',
      verbose = false,
      ida_plugins_dir = ida_plugins_dir,
      check_if_installed = false,
    })
    vim.api.nvim_create_user_command('IDAScope', function(args)
      local xml_url = (args.args ~= "") and args.args or ida_plugin.ida_xml_server
      ida_plugin.IDAScope(xml_url)
    end, { nargs = '?', desc = 'IDAScope' })
    vim.keymap.set('n', '<leader>vv', function()
      ida_plugin.IDAScope()
    end, { desc = 'Open IDAScope with Telescope' })
  end)
end

return M
