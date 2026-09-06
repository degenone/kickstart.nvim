local M = {}

local function copy_with_system(cmd, system_opts, callbacks)
  system_opts = vim.tbl_extend('force', { timeout = 5000 }, system_opts or {})
  vim.system(cmd, system_opts, function(obj)
    vim.schedule(function()
      if obj.code == 0 then
        if callbacks.on_success then
          callbacks.on_success(obj.stdout and vim.trim(obj.stdout) or '')
        end
      else
        local error_msg = obj.stderr and vim.trim(obj.stderr) or ('Command failed with code ' .. obj.code)
        if callbacks.on_error then
          callbacks.on_error(error_msg)
        end
      end
    end)
  end)
  return true
end

-- Main async copy function
-- path: string - file path to copy
-- callbacks: table with on_success(path) and on_error(error_msg) handlers
-- returns: true when the job starts, or nil on failure
function M.async_copy(path, callbacks)
  if not callbacks then
    callbacks = {}
  end

  -- Get the command to execute
  local status, file_copy_module = pcall(require, 'custom.modules.file-copy')
  if not status then
    if callbacks.on_error then
      callbacks.on_error('Failed to load file-copy module: ' .. tostring(file_copy_module))
    end
    return nil
  end

  local cmd, system_opts = file_copy_module.build_command(path)
  if not cmd or #cmd == 0 then
    if callbacks.on_error then
      callbacks.on_error('Failed to build copy command')
    end
    return nil
  end

  if vim.fn.executable(cmd[1]) ~= 1 then
    if callbacks.on_error then
      callbacks.on_error("Command '" .. cmd[1] .. "' not found in system PATH")
    end
    return nil
  end

  return copy_with_system(cmd, system_opts, callbacks)
end

return M
