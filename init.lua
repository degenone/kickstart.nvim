vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Set platform paths before vim.pack loads plugins with external dependencies.
require('config.platform')

-- Install and load plugins with the native package manager.
require('config.pack').setup()

-- Load core configuration
require 'config'
require 'keymaps'

--[[ Load all plugin specs and setup lazy
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
}) ]]

-- vim: ts=2 sts=2 sw=2 et
