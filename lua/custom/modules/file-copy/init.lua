local M = {}

local function get_os_name()
  return vim.uv.os_uname().sysname
end

function M.get_current_path()
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  if not filepath or filepath == '' then
    return nil
  end

  if not vim.bo[bufnr].buflisted then
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
    local win_ps = vim.fn.exepath 'powershell.exe'
    if win_ps == '' then
      win_ps = 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe'
    end
    return {
      win_ps,
      '-NoProfile',
      '-NonInteractive',
      '-Command',
      'Set-Clipboard -Path $args[0]',
      path,
    }, {}
  elseif os_name == 'Darwin' then
    if vim.fn.executable 'osascript' ~= 1 then return nil, 'osascript was not found in PATH' end
    return {
      'osascript',
      '-e',
      'on run argv',
      '-e',
      'set the clipboard to POSIX file (item 1 of argv)',
      '-e',
      'end run',
      '--',
      path,
    }, {}
  elseif os_name == 'Linux' then
    local wayland_display = os.getenv 'WAYLAND_DISPLAY'
    local input = vim.uri_from_fname(path) .. '\n'
    if wayland_display and wayland_display ~= '' and vim.fn.executable 'wl-copy' == 1 then
      return { 'wl-copy', '--type', 'text/uri-list' }, { stdin = input }
    end
    if vim.fn.executable 'xclip' == 1 then
      return { 'xclip', '-i', '-selection', 'clipboard', '-t', 'text/uri-list' }, { stdin = input }
    end
    if vim.fn.executable 'clip.exe' == 1 then
      -- WSL fallback. This copies the path as text because Windows clipboard
      -- file objects cannot be created reliably from a Linux process.
      return { 'clip.exe' }, { stdin = path }
    end
    return nil, 'No supported clipboard tool found (wl-copy, xclip, or clip.exe)'
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

  local cmd, system_opts = M.build_command(path)
  if not cmd then
    return false, system_opts
  end

  local result = vim.system(cmd, system_opts):wait()

  if result.code == 0 then
    return true, 'File path copied to clipboard: ' .. path
  else
    local detail = vim.trim(result.stderr or '')
    return false, ('Failed to copy file path to clipboard (exit %d): %s'):format(result.code, detail)
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

  local cmd, system_opts = M.build_command(path)
  if not cmd then
    if callback then
      callback(false, system_opts)
    else
      vim.notify(system_opts, vim.log.levels.ERROR)
    end
    return
  end

  vim.system(cmd, system_opts, function(result)
    vim.schedule(function()
      if result.code == 0 then
        local msg = 'File path copied to clipboard: ' .. path
        if callback then
          callback(true, msg)
        else
          vim.notify(msg, vim.log.levels.INFO)
        end
      else
        local detail = vim.trim(result.stderr or '')
        local msg = ('Failed to copy file path to clipboard (exit %d): %s'):format(result.code, detail)
        if callback then
          callback(false, msg)
        else
          vim.notify(msg, vim.log.levels.ERROR)
        end
      end
    end)
  end)
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
