local M = {}

local function get_os_name()
  return vim.loop.os_uname().sysname
end

local function is_path_valid(path)
  return path and path ~= '' and vim.fn.filereadable(path) == 1
end

function M.get_current_path()
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  if not filepath or filepath == '' then
    return nil
  end

  if not vim.api.nvim_buf_get_option(bufnr, 'buflisted') then
    return nil
  end

  local abs_path = vim.fn.fnamemodify(filepath, ':p')
  return abs_path ~= '' and abs_path or nil
end

function M.validate_path(path)
  if not path or path == '' then
    return false
  end

  return vim.fn.filereadable(path) == 1
end

function M.build_command(path)
  if not M.validate_path(path) then
    return nil, 'Path does not exist or is not readable: ' .. tostring(path)
  end

  local os_name = get_os_name()

  if os_name == 'Windows_NT' then
    local win_ps = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'
    local escaped = path:gsub("'", "''") -- Escape single quotes for PS

    -- We go back to the simple -Path argument since we are forced into v5.1
    return string.format('%s -NoProfile -Command "Set-Clipboard -Path \'%s\'"', win_ps, escaped)
  elseif os_name == 'Darwin' then
    return string.format('osascript -e \'tell app "Finder" to set clipboard to (POSIX file "%s")\'', path)
  elseif os_name == 'Linux' then
    local wayland_display = os.getenv 'WAYLAND_DISPLAY'
    if wayland_display and wayland_display ~= '' then
      return string.format("wl-copy --type text/uri-list 'file://%s'", path)
    else
      return string.format("echo 'file://%s' | xclip -i -selection clipboard -t text/uri-list", path)
    end
  else
    return nil, 'Unsupported operating system: ' .. os_name
  end
end

function M.copy_to_clipboard_sync(path)
  if not path then
    path = M.get_current_path()
    if not path then
      return false, 'No file path found. Please save the buffer first.'
    end
  end

  if not M.validate_path(path) then
    return false, 'Path does not exist or is not readable: ' .. path
  end

  local cmd, err = M.build_command(path)
  if not cmd then
    return false, err
  end

  local exit_code = os.execute(cmd)

  if exit_code == 0 or exit_code == true then
    return true, 'File path copied to clipboard: ' .. path
  else
    return false, 'Failed to copy file path to clipboard. Exit code: ' .. tostring(exit_code)
  end
end

function M.copy_to_clipboard(path, callback)
  if not path then
    path = M.get_current_path()
    if not path then
      local msg = 'No file path found. Please save the buffer first.'
      if callback then
        callback(false, msg)
      else
        vim.notify(msg, vim.log.levels.ERROR)
      end
      return
    end
  end

  if not M.validate_path(path) then
    local msg = 'Path does not exist or is not readable: ' .. path
    if callback then
      callback(false, msg)
    else
      vim.notify(msg, vim.log.levels.ERROR)
    end
    return
  end

  local cmd, err = M.build_command(path)
  if not cmd then
    if callback then
      callback(false, err)
    else
      vim.notify(err, vim.log.levels.ERROR)
    end
    return
  end

  vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code, _)
      if exit_code == 0 then
        local msg = 'File path copied to clipboard: ' .. path
        if callback then
          callback(true, msg)
        else
          vim.notify(msg, vim.log.levels.INFO)
        end
      else
        local msg = 'Failed to copy file path to clipboard. Exit code: ' .. tostring(exit_code)
        if callback then
          callback(false, msg)
        else
          vim.notify(msg, vim.log.levels.ERROR)
        end
      end
    end,
    on_stderr = function(_, data, _)
      if data and #data > 0 then
        vim.notify('Error: ' .. table.concat(data, '\n'), vim.log.levels.WARN)
      end
    end,
  })
end

function M.setup(opts)
  opts = opts or {}

  local keybind = opts.keybind or '<leader>yf'

  if keybind and keybind ~= '' then
    vim.keymap.set('n', keybind, function()
      M.copy_to_clipboard()
    end, {
      noremap = true,
      silent = true,
      desc = 'Copy file path to clipboard',
    })
  end

  if opts.on_copy then
    M._on_copy_callback = opts.on_copy
  end
end

return M
