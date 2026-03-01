return {
  dir = vim.fn.stdpath 'config' .. '/lua/custom/modules/file-copy',
  config = function()
    require('custom.modules.file-copy').setup {
      keybind = '<leader>cf',
    }
  end,
}
