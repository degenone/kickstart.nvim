-- Autocommands and highlights

-- Highlight trailing whitespace in every window and restore the highlight
-- whenever a colorscheme replaces highlight groups.
local function set_whitespace_highlight()
  vim.api.nvim_set_hl(0, 'ExtraWhitespace', { fg = 'red' })
end

set_whitespace_highlight()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('extra-whitespace-highlight', { clear = true }),
  callback = set_whitespace_highlight,
  desc = 'Restore trailing whitespace highlight',
})

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  group = vim.api.nvim_create_augroup('extra-whitespace-match', { clear = true }),
  callback = function()
    if vim.w.extra_whitespace_match then
      pcall(vim.fn.matchdelete, vim.w.extra_whitespace_match)
    end
    vim.w.extra_whitespace_match = vim.fn.matchadd('ExtraWhitespace', '\\s\\+$')
  end,
  desc = 'Highlight trailing whitespace in the current window',
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Disable line numbers in terminal mode
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Disable line numbers in terminal',
  group = vim.api.nvim_create_augroup('terminal-settings', { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- vim: ts=2 sts=2 sw=2 et
