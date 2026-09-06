vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
-- Keep :compiler dotnet from parsing the same diagnostics from the build
-- summary a second time.
vim.g.dotnet_errors_only = true

-- Set platform paths before vim.pack loads plugins with external dependencies.
require 'config.platform'

-- Install and load plugins with the native package manager.
require('config.pack').setup()

-- Load core configuration
require 'config'
require 'keymaps'

-- vim: ts=2 sts=2 sw=2 et
