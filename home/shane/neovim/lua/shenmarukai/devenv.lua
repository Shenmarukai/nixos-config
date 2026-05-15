-- lua/shenmarukai/devenv.lua

local M = {}

local function find_upward(names, start)
  local found = vim.fs.find(names, {
    path = start or vim.fn.getcwd(),
    upward = true,
  })[1]

  if not found then
    return nil
  end

  return vim.fs.dirname(found)
end

function M.load()
  if vim.env.DEVENV_ROOT ~= nil then
    return
  end

  local root = find_upward({ "devenv.nix", "devenv.yaml", "devenv.yml" })
  if not root then
    return
  end

  if vim.g.shenmarukai_devenv_loaded then
    return
  end

  vim.g.shenmarukai_devenv_loaded = true

  local result = vim.system({
    "devenv",
    "shell",
    "env",
    "-0",
  }, {
    cwd = root,
    text = false,
  }):wait()

  if result.code ~= 0 or not result.stdout then
    vim.notify("Failed to load devenv environment from " .. root, vim.log.levels.WARN)
    return
  end

  for entry in string.gmatch(result.stdout, "([^%z]+)") do
    local key, value = entry:match("^([^=]+)=(.*)$")
    if key and value then
      vim.env[key] = value
    end
  end

  -- Make Neovim's cwd match the project root too.
  vim.cmd.cd(vim.fn.fnameescape(root))

  vim.notify("Loaded devenv environment: " .. root, vim.log.levels.INFO)
end

M.load()

return M
