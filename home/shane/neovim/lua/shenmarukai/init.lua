local plugins = {
  '99',
  'colors',
  'cloak',
  'barbar',
  'copilot',
  'crates',
  'tree',
  'lualine',
  'telescope',
  'harpoon',
  'fugitive',
  'gh',
  'gp',
  'idascope',
  'luasnip',
  'dap',
  'lsp',
  'lint',
  'treesitter',
  'rainbow',
  'render',
  'reticle',
  'peek',
  'yazi',
  'trouble',
  'twilight',
  'zen',
  'whichkey',
  'neogit',
  'neoscroll',
  'undotree',
  'snacks',
  'opencode',
  'neotest',
}

for _, name in ipairs(plugins) do
  local ok, mod = pcall(require, 'shenmarukai.plugins.' .. name)
  if ok and type(mod) == 'table' and type(mod.setup) == 'function' then
    mod.setup()
  end
end

require('shenmarukai.set')
require('shenmarukai.remap')
require('shenmarukai.autocmds')
