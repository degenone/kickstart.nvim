-- Tokyo Night colorscheme
-- https://github.com/folke/tokyonight.nvim

return {
  'folke/tokyonight.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('tokyonight').setup {
      styles = {
        comments = { italic = false },
      },
      -- Override colors for diffs to use traditional green/red
      on_colors = function(colors)
        colors.diff = {
          add = '#2d4a22',
          delete = '#4a2222',
          change = '#2e3a5a',
          text = '#2e3a5a',
        }
      end,
    }
  end,
}
