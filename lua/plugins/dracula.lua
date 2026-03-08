-- Dracula colorscheme
-- https://github.com/Mofiqul/dracula.nvim

return {
  'Mofiqul/dracula.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('dracula').setup {
      transparent_bg = false,
      italic_comment = false,
    }
  end,
}
