-- LSP and diagnostic keybindings
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic floating window', noremap = true, silent = true })
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, { desc = 'Show code action', noremap = true, silent = true })