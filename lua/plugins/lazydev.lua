return {
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      -- Load the nvim lua runtime
      { path = 'lua', words = { 'vim', 'require' } },
    },
  },
}
