-- rest.nvim uses gq in an HTML buffer to format response bodies.
if vim.fn.executable 'prettier' == 1 then
  vim.bo.formatexpr = ''
  vim.bo.formatprg = 'prettier --parser html'
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '\nsetlocal formatexpr< formatprg<'
end
