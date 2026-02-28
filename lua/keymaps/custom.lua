-- Custom commands and keybindings
local function open_in_file_manager(select_file)
  local path = select_file and vim.fn.expand '%:p' or vim.fn.expand '%:p:h'
  local sys = vim.loop.os_uname().sysname

  if sys == 'Windows_NT' then
    if select_file then
      vim.fn.system { 'explorer', '/select,"' .. path .. '"' }
    else
      vim.fn.system { 'explorer', '"' .. path .. '"' }
    end
  elseif sys == 'Linux' then
    -- Try xdg-open (works on most distros)
    vim.fn.system { 'xdg-open', path }
  elseif sys == 'Darwin' then
    -- macOS Finder
    if select_file then
      vim.fn.system { 'open', '-R', path }
    else
      vim.fn.system { 'open', path }
    end
  else
    print('Unsupported OS: ' .. sys)
  end
end

vim.api.nvim_create_user_command('OpenInFM', function()
  open_in_file_manager(false)
end, {})

vim.api.nvim_create_user_command('RevealInFM', function()
  open_in_file_manager(true)
end, {})

-- Not working rn.
-- vim.keymap.set('n', '<leader>e', ':OpenInFM<CR>', { desc = 'Open in File Manager', silent = true })
-- vim.keymap.set('n', '<leader>E', ':RevealInFM<CR>', { desc = 'Reveal in File Manager', silent = true })