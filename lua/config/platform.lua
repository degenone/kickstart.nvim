-- Platform-specific settings

local is_windows = vim.fn.has 'win32' == 1

-- Make user-installed Lua 5.1 rocks available to Neovim. rest.nvim uses
-- mimetypes and xml2lua for optional external-body and XML support.
local function add_luarocks_paths()
  local roots = {}
  if is_windows and vim.env.APPDATA then
    roots[#roots + 1] = vim.fs.joinpath(vim.env.APPDATA, 'luarocks')
  else
    roots[#roots + 1] = vim.fs.joinpath(vim.env.HOME or '', '.luarocks')
    if vim.env.XDG_DATA_HOME then
      roots[#roots + 1] = vim.fs.joinpath(vim.env.XDG_DATA_HOME, 'luarocks')
    end
  end

  local separator = package.config:sub(1, 1) == '\\' and ';' or ':'
  local lua_paths = { package.path }
  local c_paths = { package.cpath }
  for _, root in ipairs(roots) do
    -- Windows currently uses Lua 5.1; Homebrew's LuaRocks uses Lua 5.5.
    -- These REST dependencies are pure Lua, so Neovim can load either.
    for _, version in ipairs { '5.1', '5.5' } do
      lua_paths[#lua_paths + 1] = vim.fs.joinpath(root, 'share', 'lua', version, '?.lua')
      lua_paths[#lua_paths + 1] = vim.fs.joinpath(root, 'share', 'lua', version, '?', 'init.lua')
      c_paths[#c_paths + 1] = vim.fs.joinpath(root, 'lib', 'lua', version, '?.dll')
      c_paths[#c_paths + 1] = vim.fs.joinpath(root, 'lib', 'lua', version, '?.so')
    end
  end
  package.path = table.concat(lua_paths, separator)
  package.cpath = table.concat(c_paths, separator)
end

add_luarocks_paths()

-- Windows specific settings
if vim.fn.has 'win32' == 1 then
  vim.o.shell = 'pwsh'
  vim.o.shellcmdflag =
    '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  -- vim.o.shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.o.shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
  vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  vim.o.shellquote = ''
  vim.o.shellxquote = ''
elseif vim.fn.has 'unix' == 1 then
  local python = vim.fn.exepath 'python3'
  if python ~= '' then
    vim.g.python3_host_prog = python
  end
end

-- vim: ts=2 sts=2 sw=2 et
