-- rest.nvim uses gq in a JSON buffer to format response bodies.
if vim.fn.executable 'jq' == 1 then
  vim.bo.formatexpr = ''
  vim.bo.formatprg = 'jq --indent 2 .'
  vim.b.undo_ftplugin = (vim.b.undo_ftplugin or '') .. '\nsetlocal formatexpr< formatprg<'
end
