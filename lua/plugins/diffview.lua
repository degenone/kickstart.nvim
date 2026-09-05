return {
  'dlyongemallo/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    { '<leader>gd', ':DiffviewOpen<CR>', desc = 'Open diff view' },
    { '<leader>gh', ':DiffviewFileHistory<CR>', desc = 'File history' },
    { '<leader>gc', ':DiffviewClose<CR>', desc = 'Close diff view' },
  },
  config = function()
    require('diffview').setup {
      diff_binaries = false,
      enhanced_diff_hl = true,
      auto_refresh = true,
      view = {
        merge_tool = {
          layout = 'diff3_mixed',
        },
      },
      file_panel = {
        win_config = {
          position = 'left',
          width = 35,
        },
      },
      file_history_panel = {
        win_config = {
          position = 'bottom',
          height = 16,
        },
      },
    }
  end,
}
