-- VS Code theme
-- https://github.com/Mofiqul/vscode.nvim

return {
  'Mofiqul/vscode.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('vscode').setup {
      -- Enable transparent background
      transparent = false,
      -- Enable italic comment
      italic_comments = false,
      -- Disable nvim-tree background color
      disable_nvimtree_bg = true,
    }
  end,
}
