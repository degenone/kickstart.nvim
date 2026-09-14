-- Custom plugins that live outside this repository are optional. Set
-- NVIM_CODE_ASSISTANT_DIR to override the platform-specific checkout path.
local plugins = {
  require 'custom.plugins.file-copy',
}

local code_assistant_dir = vim.env.NVIM_CODE_ASSISTANT_DIR
if not code_assistant_dir and vim.fn.has('win32') == 1 then
  code_assistant_dir = 'D:\\learn-lua\\plugin'
elseif not code_assistant_dir and vim.fn.has('macunix') == 1 then
  code_assistant_dir = vim.fn.expand '~/dev/code-complete-plugin'
end
if code_assistant_dir and vim.uv.fs_stat(code_assistant_dir) then
  plugins[#plugins + 1] = {
    dir = code_assistant_dir,
    name = 'code_assistant',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('code_assistant').setup {
        model = vim.fn.has('macunix') == 1 and 'gemma4:31b-cloud' or 'qwen3-coder-next:cloud',
        keymap = '<leader>cc',
        debug = false,
        keep_alive = 0,
      }
    end,
  }
end

return plugins
