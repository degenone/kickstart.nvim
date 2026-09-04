vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Make user-installed Lua 5.1 rocks available to Neovim. This is used by
-- rest.nvim for optional XML and external-body support on Windows.
if vim.fn.has 'win32' == 1 and vim.env.APPDATA then
  local luarocks = vim.fs.joinpath(vim.env.APPDATA, 'luarocks')
  package.path = table.concat({
    package.path,
    vim.fs.joinpath(luarocks, 'share', 'lua', '5.1', '?.lua'),
    vim.fs.joinpath(luarocks, 'share', 'lua', '5.1', '?', 'init.lua'),
  }, ';')
  package.cpath = table.concat({
    package.cpath,
    vim.fs.joinpath(luarocks, 'lib', 'lua', '5.1', '?.dll'),
  }, ';')
end

-- Load core configuration
require 'config'
require 'keymaps'

-- Bootstrap and setup lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load all plugin specs and setup lazy
require('lazy').setup({
  { import = 'plugins' },
  { import = 'custom.plugins' },
}, {
  pkg = {
    -- Do not resolve plugin rockspecs; this setup uses Git plugins and
    -- Windows-native tools instead of LuaRocks.
    sources = { 'lazy', 'packspec' },
  },
  rocks = {
    -- Keep plugin installation self-contained on Windows; rest.nvim's core
    -- HTTP client uses curl and does not require LuaRocks.
    enabled = false,
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et
