return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('render-markdown').setup {
      -- Preview Markdown in normal mode and expose the source while editing.
      render_modes = { 'n', 'c', 't' },
    }
  end,
}
