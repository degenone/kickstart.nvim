return {
  'mbbill/undotree',
  cmd = { 'UndotreeToggle', 'UndotreeShow' },
  keys = {
    { '<leader>u', '<cmd>UndotreeToggle<CR>', desc = 'Toggle undo tree' }
  },
  config = function()
    -- Create undotree data directory
    local undotree_dir = vim.fn.stdpath('data') .. '/undotree'
    vim.fn.mkdir(undotree_dir, 'p')

    -- Configure undotree
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_SplitWidth = 30
    vim.g.undotree_DiffpanelHeight = 10
    vim.g.undotree_ShortIndicators = 1
    vim.opt.undodir = undotree_dir
  end
}
