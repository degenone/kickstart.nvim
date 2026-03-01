local M = {}

-- Helper to get Neovim version
local function has_system()
  return vim.fn.has("nvim-0.9") == 1
end

-- Execute async copy using vim.system() (Neovim 0.9+)
local function copy_with_system(cmd, callbacks)
  vim.system(cmd, { timeout = 5000 }, function(obj)
    if obj.code == 0 then
      if callbacks.on_success then
        callbacks.on_success(obj.stdout and vim.trim(obj.stdout) or "")
      end
    else
      local error_msg = obj.stderr and vim.trim(obj.stderr) or ("Command failed with code " .. obj.code)
      if callbacks.on_error then
        callbacks.on_error(error_msg)
      end
    end
  end)
  return true
end

-- Execute async copy using vim.fn.jobstart() (older versions)
local function copy_with_jobstart(cmd, callbacks)
  local cmd_string = table.concat(cmd, " ")
  local job_id = vim.fn.jobstart(cmd_string, {
    on_stdout = function(_, data, _)
      if callbacks.on_success and data and #data > 0 then
        callbacks.on_success(vim.trim(table.concat(data, "\n")))
      end
    end,
    on_stderr = function(_, data, _)
      if callbacks.on_error and data and #data > 0 then
        callbacks.on_error(vim.trim(table.concat(data, "\n")))
      end
    end,
    on_exit = function(_, code, _)
      if code ~= 0 and callbacks.on_error then
        callbacks.on_error("Job exited with code " .. code)
      elseif code == 0 and callbacks.on_success and not callbacks._success_called then
        callbacks._success_called = true
        callbacks.on_success("")
      end
    end,
  })

  if job_id <= 0 then
    if callbacks.on_error then
      callbacks.on_error("Failed to create job")
    end
    return nil
  end

  -- Add timeout protection (5s max)
  vim.defer_fn(function()
    if vim.fn.jobwait({ job_id }, 0)[1] == -1 then
      vim.fn.jobstop(job_id)
      if callbacks.on_error then
        callbacks.on_error("Job execution timeout (5s exceeded)")
      end
    end
  end, 5000)

  return job_id
end

-- Main async copy function
-- path: string - file path to copy
-- callbacks: table with on_success(path) and on_error(error_msg) handlers
-- returns: true (vim.system) or job_id (jobstart), or nil on failure
function M.async_copy(path, callbacks)
  if not callbacks then
    callbacks = {}
  end

  -- Get the command to execute
  local status, file_copy_module = pcall(require, "custom.modules.file-copy")
  if not status then
    if callbacks.on_error then
      callbacks.on_error("Failed to load file-copy module: " .. tostring(file_copy_module))
    end
    return nil
  end

  local cmd = file_copy_module.build_command(path)
  if not cmd or #cmd == 0 then
    if callbacks.on_error then
      callbacks.on_error("Failed to build copy command")
    end
    return nil
  end

  -- Check for required system utilities
  if not vim.fn.executable(cmd[1]) then
    if callbacks.on_error then
      callbacks.on_error("Command '" .. cmd[1] .. "' not found in system PATH")
    end
    return nil
  end

  -- Execute based on Neovim version
  if has_system() then
    return copy_with_system(cmd, callbacks)
  else
    return copy_with_jobstart(cmd, callbacks)
  end
end

return M
