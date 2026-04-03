-- Return custom plugin specs for lazy.nvim
return {
  require 'custom.plugins.file-copy',
  {
    dir = 'D:\\learn-lua\\plugin',
    name = 'code_assistant',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('code_assistant').setup {
        model = 'qwen3-coder-next:cloud', --'kimi-k2.5:cloud', -- qwen3-coder seems to work better
        keymap = '<leader>cc',
        debug = false,
        keep_warm = false,
      }
    end,
  },
}
