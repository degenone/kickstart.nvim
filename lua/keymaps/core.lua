-- Core keybindings for NeoVim
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clear search highlights with Escape
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic quickfix list
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode with Escape+Escape
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Tab movement
vim.keymap.set('n', '<left>', 'gT', { desc = 'Move to previous tab' })
vim.keymap.set('n', '<right>', 'gt', { desc = 'Move to next tab' })

-- Move lines up and down with Alt-j/k (Alt is represented as <A-...>)
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'move line up', silent = true })
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'move line down', silent = true })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'move lines down', silent = true })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'move lines up', silent = true })

-- Line movement
vim.keymap.set('n', '<leader>,', '_', { desc = 'move to the start of a line', silent = true })
vim.keymap.set('n', '<leader>.', '$', { desc = 'move to the end of a line', silent = true })
vim.keymap.set('v', '<leader>,', '_', { desc = 'move to the start of a line', silent = true })
vim.keymap.set('v', '<leader>.', '$', { desc = 'move to the end of a line', silent = true })
