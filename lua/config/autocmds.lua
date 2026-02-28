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

-- vim: ts=2 sts=2 sw=2 et
