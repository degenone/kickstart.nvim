# TODO

- [x] Add module for copying buffer/file to clipboard
- [x] Add [diff view](https://github.com/sindrets/diffview.nvim)
- [x] Add undo-tree module

## File-Copy Module (Complete)

The file-copy module is now implemented as a custom plugin that allows copying the current file to the OS clipboard in file-manager format.

### Usage Instructions

- **Location**: `lua/custom/modules/file-copy/`
- **Keybinding**: `<leader>cf` (default)
- **Description**: Copies the current file to OS clipboard in file-manager format
- **How to Paste**: Press `Ctrl+V` in file manager or chat application to paste the actual file (not just path)

### Customizing the Keybinding

To change the default keybinding, update your plugin config in `init.lua`:

```lua
require("custom.modules.file-copy").setup({
  keybind = "<leader>cy" -- Change to your preferred keybinding
})
```

### Implementation Notes

- **Async Execution**: The module uses asynchronous command execution to prevent blocking Neovim
- **Notifications**: Displays a popup notification when file is successfully copied, or error notification if copy fails
- **Cross-Platform Support**:
  - Windows: Uses PowerShell `Set-Clipboard` with CF_HDROP format
  - macOS: Uses AppleScript to set Finder's clipboard
  - Linux: Uses `xclip` (X11) or `wl-copy` (Wayland) with text/uri-list MIME type

---

## Implementation Reference (Original Spec)

## 1. Plugin Directory Structure

To make this a real plugin, create a folder (e.g., `~/projects/file-copy.nvim`) with the following hierarchy:

```text
file-copy.nvim/
├── lua/
│   └── file-copy/
│       └── init.lua   <-- Main logic goes here
└── plugin/
    └── file-copy.lua  <-- Optional: Auto-load commands

```

---

## 2. The Implementation (`lua/file-copy/init.lua`)

This script detects the OS and executes the specific system command to place the file reference onto the system clipboard.

```lua
local M = {}

-- Helper to get the absolute path of the current buffer
local function get_current_path()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("Buffer has no file path", vim.log.levels.WARN)
    return nil
  end
  return path
end

-- The core "Copy" function
M.copy_to_clipboard = function()
  local path = get_current_path()
  if not path then return end

  local os_name = vim.loop.os_uname().sysname
  local cmd = ""

  if os_name == "Windows_NT" then
    -- Windows: Uses PowerShell to set CF_HDROP format
    cmd = string.format("powershell.exe -Command \"Set-Clipboard -Path '%s'\"", path)
  
  elseif os_name == "Darwin" then
    -- macOS: Uses AppleScript to set the Finder's clipboard
    cmd = string.format("osascript -e 'tell app \"Finder\" to set the clipboard to (POSIX file \"%s\")'", path)
  
  elseif os_name == "Linux" then
    -- Linux: Requires xclip (X11) or wl-copy (Wayland)
    if os.getenv("WAYLAND_DISPLAY") then
      cmd = string.format("wl-copy --type text/uri-list 'file://%s'", path)
    else
      cmd = string.format("echo 'file://%s' | xclip -i -selection clipboard -t text/uri-list", path)
    end
  end

  -- Execute the command silently
  local success = os.execute(cmd)
  
  if success then
    vim.notify("File copied to OS clipboard: " .. vim.fn.fnamemodify(path, ":t"))
  else
    vim.notify("Failed to copy file to clipboard.", vim.log.levels.ERROR)
  end
end

-- Setup function for user configuration
M.setup = function(opts)
  opts = opts or {}
  local keybind = opts.keybind or "<leader>cf"
  
  vim.keymap.set('n', keybind, M.copy_to_clipboard, { 
    desc = "Copy current file to OS clipboard" 
  })
end

return M

```

---

## 3. How to Install & Use

### Using Lazy.nvim

If you want to use this locally before publishing it to GitHub, add this to your `lazy` setup:

```lua
{
  dir = "~/projects/file-copy.nvim", -- Path to your plugin folder
  config = function()
    require("file-copy").setup({
      keybind = "<leader>cf" -- Optional: change your keybind here
    })
  end
}

```

### Manual Usage

Once installed, simply open any file in NeoVim and press `<leader>cf`. You can then go to a chat window (like Discord or Slack) and press **Ctrl+V** (or **Cmd+V**) to paste the actual file.

---

## 4. Technical Comparison

It's important to understand why this method is superior to a simple "Copy Path" script.

| Feature | Standard Clipboard (`+` register) | Your New Plugin |
| --- | --- | --- |
| **Data Type** | String (Text) | File Descriptor (Binary/Pointer) |
| **Pasting in Chat** | Pastes the path string (e.g., `C:/Users/file.txt`) | Uploads the **actual file** |
| **Pasting in Explorer** | Does nothing | Copies the file to that folder |
| **Dependencies** | None | `powershell` (Win), `osascript` (Mac), `xclip` (Linux) |

---

---

## Diffview.nvim (Complete)

- **Location**: `lua/plugins/diffview.lua`
- **Keybindings**:
  - `<leader>gd` - Open diff view for current changes
  - `<leader>gh` - View file history
  - `<leader>gc` - Close diff view (or press q)
- **Usage**: Great for reviewing git changes side-by-side
- **Lazy Load**: Loads on first command execution

---

## Undotree (Complete)

- **Location**: `lua/plugins/undotree.lua`
- **Keybinding**: `<leader>u` - Toggle undo tree panel
- **Usage**: Visual navigation of undo/redo history
- **Data Storage**: Undo history persisted in `data/undotree/`
- **Lazy Load**: Loads on first command execution

---

## Next Steps

File-copy, diffview, and undotree modules are all complete. Configuration and plugins are fully functional.
