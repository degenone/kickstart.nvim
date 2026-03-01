local M = {}

function M.show_success(filename)
  vim.schedule(function()
    -- Get just the filename (basename)
    local basename = vim.fn.fnamemodify(filename, ":t")
    local message = "File copied: " .. basename
    
    -- Show notification with auto-dismiss after 3 seconds
    vim.notify(message, vim.log.levels.INFO, {
      timeout = 3000
    })
  end)
end

function M.show_error(error_msg)
  vim.schedule(function()
    local message = "Error copying file: " .. error_msg
    
    -- Show error notification, no auto-dismiss
    vim.notify(message, vim.log.levels.ERROR, {
      timeout = false
    })
  end)
end

function M.show_info(message)
  vim.schedule(function()
    vim.notify(message, vim.log.levels.INFO)
  end)
end

return M
