-- Gruvbox colorscheme
-- https://github.com/ellisonleao/gruvbox.nvim

return {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('gruvbox').setup {
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      },
    }
  end,
}
