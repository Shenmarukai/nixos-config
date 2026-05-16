local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local ShenmarukaiGroup = augroup('Shenmarukai', {})
local yank_group = augroup('HighlightYank', {})

vim.cmd('syntax on')

---@param name string
function _G.R(name)
  require('plenary.reload').reload_module(name)
end

function _G.SmallTabLanguage(filetype)
  if filetype == 'html'
      or filetype == 'css'
      or filetype == 'javascript'
      or filetype == 'typescript'
      or filetype == 'javascriptreact'
      or filetype == 'typescriptreact'
      or filetype == 'json'
      or filetype == 'xml' then
    return true
  end
end

function _G.MediumTabLanguage(filetype)
  if filetype == 'lua'
      or filetype == 'python'
      or filetype == 'c'
      or filetype == 'c++'
      or filetype == 'c#'
      or filetype == 'rust'
      or filetype == 'markdown' then
    return true
  end
end

function _G.LargeTabLanguage(_)
  return false
end

function _G.ColorMyPencils()
end

vim.filetype.add({
  extension = {
    templ = 'templ',
  },
})

vim.g.barbar_auto_setup = false
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

local function enable_inlay_hints(bufnr)
  if vim.lsp.inlay_hint then
    local ok = pcall(vim.lsp.inlay_hint, bufnr, true)
    if not ok then
      pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
    end
  end
end

autocmd('VimEnter', {
  callback = function()
    local ok, api = pcall(require, 'nvim-tree.api')
    if ok then
      api.tree.open()
    end
    pcall(vim.cmd.colorscheme, 'catppuccin')
  end,
})

autocmd('TextYankPost', {
  group = yank_group,
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 40,
    })
  end,
})

autocmd({ 'BufWritePre' }, {
  group = ShenmarukaiGroup,
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
  group = ShenmarukaiGroup,
  callback = function(e)
    local filetype = vim.bo.filetype
    vim.diagnostic.config({ virtual_text = true })
    vim.diagnostic.show()
    enable_inlay_hints(e.buf)
    if filetype ~= 'NvimTree' then
      vim.opt.list = true
      vim.opt.listchars = {
        tab = '│ ',
        leadmultispace = '│   ',
        trail = '·',
        extends = '»',
        precedes = '«',
        conceal = '*',
      }
    else
      vim.opt.list = true
      vim.opt.listchars = {
        tab = '│ ',
        leadmultispace = '│ ',
        extends = '»',
        precedes = '«',
        conceal = '*',
      }
    end
    local opts = { buffer = e.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
  end,
})

autocmd('BufEnter', {
  group = ShenmarukaiGroup,
  callback = function()
    pcall(vim.cmd.colorscheme, 'catppuccin')
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

autocmd({ 'ModeChanged', 'BufEnter' }, {
  group = ShenmarukaiGroup,
  callback = function()
    local mode = vim.fn.mode(1)
    local filetype = vim.bo.filetype
    local buftype = vim.bo.buftype

    if buftype == '' then
      if mode == 'i' or mode == 'v' or mode == 'V' or mode == '\x16' then
        vim.opt_local.list = true
        vim.opt_local.listchars = {
          tab = '┼─',
          space = '·',
          lead = '·',
          leadmultispace = '│···',
          trail = '·',
          eol = '↲',
          nbsp = '␣',
          extends = '»',
          precedes = '«',
          conceal = '*',
        }
      elseif mode == 'n' then
        vim.opt_local.list = true
        vim.opt_local.listchars = {
          tab = '│ ',
          leadmultispace = '│   ',
          trail = '·',
          extends = '»',
          precedes = '«',
          conceal = '*',
        }
      else
        vim.opt_local.list = false
      end
    elseif buftype == 'nofile' then
      if filetype == 'NvimTree' then
        vim.opt_local.list = false
      else
        vim.opt_local.list = false
      end
    elseif buftype == 'terminal' then
      if filetype == 'opencode_terminal' then
        vim.opt_local.list = false
      else
        vim.opt_local.list = false
      end
    end
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'hexpat' then
      vim.diagnostic.enable(false, { bufnr = args.buf })
    end
  end,
})
