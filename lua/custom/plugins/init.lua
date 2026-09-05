-- Custom plugins that live outside this repository are optional. Set
-- NVIM_CODE_ASSISTANT_DIR to their absolute path on any machine that has them.
local plugins = {
  require 'custom.plugins.file-copy',
}

local code_assistant_dir = vim.env.NVIM_CODE_ASSISTANT_DIR
if not code_assistant_dir and vim.fn.has('win32') == 1 then
  code_assistant_dir = 'D:\\learn-lua\\plugin'
end
if code_assistant_dir and vim.uv.fs_stat(code_assistant_dir) then
  plugins[#plugins + 1] = {
    dir = code_assistant_dir,
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
  }
end

return plugins
