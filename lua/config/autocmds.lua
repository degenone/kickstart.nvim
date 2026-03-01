-- Autocommands and highlights

-- Highlight trailing spaces with red dot.
vim.cmd 'highlight ExtraWhitespace guifg=red'
vim.cmd 'match ExtraWhitespace /\\s\\+$/'

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
