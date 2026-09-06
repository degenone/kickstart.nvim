-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  -- Load before startup directory buffers so Neo-tree can replace Netrw.
  lazy = false,
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree toggle<CR>', desc = 'NeoTree toggle' },
  },
  opts = {
    filesystem = {
      -- Keep the directory tree in Neo-tree's normal sidebar position.
      hijack_netrw_behavior = 'open_default',
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
