vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

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
