# NeoVim Configuration Architecture Guide

## Architecture Overview

This NeoVim configuration follows a **modular architecture** where functionality is separated into distinct directories and modules. This approach offers several key benefits:

- **Maintainability**: Each module handles a specific concern (settings, keybindings, plugins), making the codebase easier to understand and modify.
- **Scalability**: Adding new settings, keybindings, or plugins is straightforward—simply create a new file in the appropriate directory.
- **Modularity**: Changes to one module don't affect others, reducing the risk of breaking existing functionality.
- **Clarity**: By organizing code logically, new users can quickly find where to make changes.
- **Reusability**: Common patterns and utilities can be shared across modules.

## Directory Structure

```
nvim/
├── init.lua                          # Main entry point; bootstrap lazy.nvim and load plugin specs
├── lua/
│   ├── config/                       # Core editor configuration
│   │   ├── init.lua                  # Initialization file - loads all config modules
│   │   ├── platform.lua              # Platform-specific settings (Windows, Unix, etc.)
│   │   ├── settings.lua              # Core editor settings (options, visual config)
│   │   └── autocmds.lua              # Automatic commands (autocommands for events)
│   │
│   ├── keymaps/                      # Keybinding configuration
│   │   ├── init.lua                  # Initialization file - loads all keymap modules
│   │   ├── core.lua                  # Core navigation and editing keybindings
│   │   ├── diagnostics.lua           # LSP diagnostics and code action keybindings
│   │   └── custom.lua                # User-defined custom keybindings
│   │
│   ├── plugins/                      # Individual plugin configurations
│   │   ├── init.lua                  # Entry point for all plugins (lazy.nvim imports this)
│   │   ├── lsp.lua                   # Language Server Protocol setup with Mason
│   │   ├── completion.lua            # Autocompletion (nvim-cmp, LuaSnip)
│   │   ├── telescope.lua             # Fuzzy finder and search
│   │   ├── treesitter.lua            # Syntax highlighting and parsing
│   │   ├── colorscheme.lua           # Color scheme configuration
│   │   ├── gitsigns.lua              # Git integration in gutter
│   │   ├── conform.lua               # Code formatting
│   │   ├── lint.lua                  # Linting configuration
│   │   ├── neo-tree.lua              # File explorer
│   │   ├── autopairs.lua             # Auto-closing brackets/quotes
│   │   ├── mini.lua                  # Mini.nvim utilities (AI text objects, surround, statusline)
│   │   ├── debug.lua                 # Debugging setup
│   │   ├── indent_line.lua           # Indent guides
│   │   ├── vim-sleuth.lua            # Auto-detect indentation
│   │   ├── lazydev.lua               # NeoVim API development utilities
│   │   └── custom.lua                # User-defined custom plugins (if needed)
│   │
│   ├── kickstart/                    # Kickstart-derived modules (shared utilities)
│   │   └── health.lua                # Health check script for diagnostics
│   │
│   └── custom/                       # User customizations
│       └── plugins/
│           └── init.lua              # User custom plugins go here
│
├── doc/
│   └── CONFIG.md                     # This file - architecture documentation
│
└── .stylua.toml                      # Lua formatting configuration
```

## Module Responsibilities

### Core Configuration (`lua/config/`)

#### `config/init.lua`
- **Purpose**: Initialization hub for all configuration modules.
- **Responsibilities**: Loads all submodules in order.
- **Load Order**: `platform` → `settings` → `autocmds`

#### `config/platform.lua`
- **Purpose**: Handle platform-specific differences.
- **Responsibilities**: 
  - Windows-specific shell configuration (PowerShell setup, encoding)
  - Unix-specific configuration (Python path, etc.)
- **When to Edit**: When adding platform-specific behaviors (e.g., shell configuration).

#### `config/settings.lua`
- **Purpose**: Define core editor options and visual settings.
- **Responsibilities**: 
  - Line numbers, relative numbering, cursor behavior
  - Mouse support, clipboard integration
  - UI elements (signcolumn, listchars, colors)
  - Search behavior and indentation
- **When to Edit**: When changing editor appearance or behavior (e.g., tabs vs spaces, line number style).

#### `config/autocmds.lua`
- **Purpose**: Define automatic commands for various events.
- **Responsibilities**: 
  - Text yank highlighting (visual feedback when copying)
  - Event-driven automation
- **When to Edit**: When adding automatic behaviors triggered by events.

### Keybindings (`lua/keymaps/`)

#### `keymaps/init.lua`
- **Purpose**: Initialization hub for all keybinding modules.
- **Responsibilities**: Loads all keymap submodules in order.

#### `keymaps/core.lua`
- **Purpose**: Core navigation and editing keybindings.
- **Responsibilities**: Movement, window/buffer management, basic editing commands.
- **When to Edit**: When changing fundamental navigation keybindings.

#### `keymaps/diagnostics.lua`
- **Purpose**: LSP, diagnostics, and code action keybindings.
- **Responsibilities**: Navigation to errors, code actions, hover info.
- **When to Edit**: When adjusting LSP-related keybindings.

#### `keymaps/custom.lua`
- **Purpose**: User-defined custom keybindings.
- **Responsibilities**: All personal/project-specific keybindings.
- **When to Edit**: When adding your own keybindings.

### Plugins (`lua/plugins/`)

Each plugin file is a **Lua module** that returns a **lazy.nvim plugin specification**.

#### Plugin File Structure
Each plugin file follows this pattern:
```lua
return {
  'author/plugin-name',
  -- Plugin configuration goes here
  opts = { ... },
  config = function() ... end,
  keys = { ... },
  event = { ... },
  dependencies = { ... },
}
```

#### Individual Plugins

- **`lsp.lua`**: Language Server Protocol, Mason (LSP installer), diagnostics, code actions
- **`completion.lua`**: nvim-cmp (autocompletion), LuaSnip (snippet expansion), friendly snippets
- **`telescope.lua`**: Fuzzy finder for files, buffers, search, and LSP symbols
- **`treesitter.lua`**: Syntax highlighting, code parsing, structural navigation
- **`colorscheme.lua`**: Visual Studio Code theme and highlight configuration
- **`gitsigns.lua`**: Git integration - shows changes in gutter, provides diff operations
- **`conform.lua`**: Code formatting on save or on-demand
- **`lint.lua`**: Linting support (syntax and code quality checking)
- **`neo-tree.lua`**: File explorer sidebar with tree navigation
- **`autopairs.lua`**: Auto-closing brackets and quotes
- **`mini.lua`**: Collection of small utilities (text objects, surround, statusline)
- **`debug.lua`**: Debugging support with DAP (Debug Adapter Protocol)
- **`indent_line.lua`**: Visual indent guides
- **`vim-sleuth.lua`**: Auto-detects indentation style from files
- **`lazydev.lua`**: NeoVim API documentation and development utilities

#### `plugins/init.lua`
- **Purpose**: Lazy plugin loader entry point.
- **Responsibilities**: Imports all plugin specifications for lazy.nvim.
- **Note**: This file should contain `return {}` or `{ import = 'plugins' }` directives.

### Custom Plugins (`lua/custom/plugins/`)

- **Purpose**: Space for user-defined plugins and personal extensions.
- **Responsibilities**: User-contributed plugin configurations.
- **When to Edit**: When adding your own plugin specifications or overrides.

### Kickstart Utilities (`lua/kickstart/`)

- **`health.lua`**: Health check module for diagnosing configuration issues.
- **Purpose**: Shared utilities derived from the kickstart template.

## How to Add/Edit

### Adding New Settings

1. **Open** `lua/config/settings.lua`
2. **Add** your new setting:
   ```lua
   vim.opt.your_option = value
   ```
3. **Save** and restart NeoVim or run `:source $MYVIMRC`

**Example**: To enable spell checking:
```lua
vim.opt.spell = true
vim.opt.spelllang = { 'en_us' }
```

### Adding New Keybindings

1. **Identify** the category (core navigation, diagnostics, custom, etc.)
2. **Open** the appropriate file in `lua/keymaps/`:
   - **Navigation/editing** → `core.lua`
   - **LSP/diagnostics** → `diagnostics.lua`
   - **Personal/project** → `custom.lua`
3. **Add** your keymap:
   ```lua
   vim.keymap.set('n', '<leader>xx', function()
     -- your action here
   end, { desc = 'Description of what this does' })
   ```
   - `'n'` = normal mode (use `'i'` for insert, `'x'` for visual, etc.)
   - `'<leader>xx'` = your key combination
   - `desc` = shows up in which-key and help

**Example**: Add a keymap to toggle spell checking:
```lua
vim.keymap.set('n', '<leader>ts', function()
  vim.opt.spell = not vim.opt.spell
end, { desc = '[T]oggle [S]pell' })
```

### Adding New Plugins

1. **Create** a new file in `lua/plugins/` (e.g., `my-plugin.lua`)
2. **Return** a lazy.nvim plugin specification:
   ```lua
   return {
     'author/plugin-name',
     event = 'VimEnter',
     opts = {
       -- plugin options
     },
     config = function(plugin, opts)
       -- plugin setup code
     end,
     keys = {
       { '<leader>key', function() ... end, desc = 'Description' },
     },
   }
   ```
3. **Save** the file. It will be auto-loaded via `lua/plugins/init.lua`

**Example**: Add a plugin for better comments:
```lua
return {
  'numToStr/Comment.nvim',
  event = 'VimEnter',
  config = function()
    require('Comment').setup()
  end,
  keys = {
    { 'gcc', mode = 'n', desc = 'Comment toggle current line' },
    { 'gc', mode = 'v', desc = 'Comment toggle' },
  },
}
```

### Enabling/Disabling Plugins

#### Disable a Plugin

**Option 1**: Comment out the plugin spec in `lua/plugins/xxx.lua`:
```lua
-- return {
--   'author/plugin-name',
--   ...
-- }
```

**Option 2**: Add `enabled = false` to the spec:
```lua
return {
  'author/plugin-name',
  enabled = false,  -- Disables loading this plugin
  ...
}
```

**Option 3**: Conditionally enable based on file type:
```lua
return {
  'author/plugin-name',
  ft = { 'python', 'lua' },  -- Only load for Python and Lua files
  ...
}
```

#### Enable a Plugin

- Remove the comments or set `enabled = true`
- Restart NeoVim

## Dependencies and Load Order

The configuration follows a **strict initialization order** to ensure dependencies are available before they're used:

### 1. Main Entry Point: `init.lua`
```
init.lua
├─ Platform & Basic Setup (inline)
├─ require('keymaps')           ← Load keybindings early
├─ Lazy plugin manager bootstrap
├─ require('lazy').setup(...)   ← Load plugins
│  ├─ Loads lua/plugins/xxx.lua specs
│  └─ Loads lua/custom/plugins/
└─ Lazy UI configuration
```

### 2. Config Initialization: `lua/config/init.lua`
**This is NOT called in `init.lua`** because settings are already inline. However, if refactoring is needed:
```
config/init.lua
├─ require('config.platform')     ← Platform-specific shell setup
├─ require('config.settings')     ← Editor options and UI
└─ require('config.autocmds')     ← Automatic commands
```

### 3. Keymaps Initialization: `lua/keymaps/init.lua`
```
keymaps/init.lua
├─ require('keymaps.core')        ← Basic navigation
├─ require('keymaps.diagnostics') ← LSP keybindings
└─ require('keymaps.custom')      ← User custom keybindings
```

### 4. Plugin Loading: `lua/plugins/init.lua` & Individual Specs
- lazy.nvim loads each plugin spec according to its `event`, `cmd`, or `keys` triggers
- Plugin-specific keybindings are defined inline in each plugin file
- LSP keybindings are attached on `LspAttach` event

### Load Order Guarantee

⚠️ **Important**: Some plugins depend on others. lazy.nvim respects `dependencies`:
```lua
return {
  'plugin-name',
  dependencies = {
    'other-plugin',  -- This loads first
  },
}
```

If a plugin fails to load, check its dependencies are available.

## Troubleshooting

### Issue: Changes to settings don't take effect

**Solution**: 
- Restart NeoVim completely (exit and reopen)
- Or run `:source $MYVIMRC` to reload the configuration
- Or run `:luafile %` in the modified file

### Issue: Keybindings not working

**Possible Causes**:
1. **Conflicting mappings** - Another plugin maps the same key
   - Run `:verbose map <your-key>` to see what's mapped
2. **Wrong mode** - Using `'n'` (normal) when it should be `'i'` (insert)
   - Check the mode string in your keymap
3. **Typo in the spec** - Missing `desc` or syntax error
   - Check NeoVim error log: `:messages`

**Solution**:
- Use `:map <key>` to list all mappings for a key
- Use `:verbose map <key>` to see where it's mapped
- Check `:messages` for errors during startup

### Issue: Plugin not loading

**Possible Causes**:
1. **Plugin spec has `enabled = false`**
   - Remove or set to `true`
2. **Dependencies not installed** - Lazy.nvim should auto-install
   - Run `:Lazy` to see status
3. **Event/trigger not met** - Plugin only loads on certain events
   - Check the `event`, `cmd`, or `keys` triggers

**Solution**:
- Run `:Lazy` to open the lazy.nvim UI
- Look for red X or error indicators
- Press `?` in lazy.nvim UI for help
- Check error messages: `:messages`

### Issue: Syntax errors in configuration

**Solution**:
1. Check the error message: `:messages`
2. Look for line numbers and file names
3. Verify Lua syntax (quotes, parentheses, commas)
4. Use a Lua linter in your editor if available

**Common Mistakes**:
```lua
-- ❌ Missing comma
return {
  'plugin-name'  -- Comma missing here!
  opts = { ... }
}

-- ✅ Correct
return {
  'plugin-name',
  opts = { ... }
}

-- ❌ Unmatched quotes
vim.opt.listchars = { tab = '» ' }  -- Missing closing quote

-- ✅ Correct
vim.opt.listchars = { tab = '» ', nbsp = '␣' }
```

### Issue: Colors look wrong or theme not applied

**Solution**:
1. Check `lua/plugins/colorscheme.lua` for theme name
2. Ensure the colorscheme plugin is loaded:
   - Run `:Lazy` and search for the colorscheme plugin
3. Force color update:
   - Run `:colorscheme <name>` manually
4. Check terminal supports 24-bit color:
   - Set `TERM=xterm-256color` in your shell

### Issue: LSP not working (no code intelligence)

**Possible Causes**:
1. **Language server not installed** - Mason must install it
2. **Wrong file type** - LSP only activates for configured languages
3. **Configuration error** - Check `lua/plugins/lsp.lua`

**Solution**:
1. Run `:LspInfo` to see active LSP servers
2. Run `:MasonInfo` to see installed language servers
3. Install missing servers: `:Mason` and search/install

### Issue: Slow startup or lag

**Possible Causes**:
1. **Too many plugins loaded eagerly** - Plugins should use `event`, `cmd`, or `keys`
2. **Heavy plugin initialization** - Check `config` functions
3. **Large files or many open buffers**

**Solution**:
- Run `:Lazy profile` to see startup times
- Check lazy.nvim UI for slow plugins
- Move plugin loading to be lazy (event/cmd/keys) instead of immediate

## Migration Notes

### Changes from Monolithic Configuration

This configuration represents a migration from a single large `init.lua` to a **modular architecture**:

#### Before (Monolithic)
- Single `init.lua` file with **hundreds of lines**
- All settings, keybindings, and plugins mixed together
- Difficult to navigate and maintain
- Hard to find where to add new features

#### After (Modular)
- **Organized by concern**: config, keymaps, plugins
- **Each plugin has its own file** in `lua/plugins/`
- **Settings separated** into logical modules
- **Clear load order** and initialization flow
- **Easy to extend** - just create new files

### Key Structural Changes

1. **Settings** moved from `init.lua` to `lua/config/settings.lua`
   - Platform-specific logic isolated in `lua/config/platform.lua`
   - Autocmds isolated in `lua/config/autocmds.lua`

2. **Keybindings** reorganized into `lua/keymaps/`
   - Core keybindings in `core.lua`
   - LSP keybindings in `diagnostics.lua`
   - User keybindings in `custom.lua`

3. **Plugin configuration** split into individual files
   - Each plugin in its own file under `lua/plugins/`
   - Lazy.nvim imports all specs automatically
   - Plugin-specific keybindings stay with plugin code

4. **Plugin manager**: lazy.nvim (replaces packer or vim-plug if used)
   - Automatic lazy loading based on `event`, `cmd`, `keys`
   - Better performance and dependency management
   - Easy UI with `:Lazy` command

### How to Migrate Custom Settings

If you had custom settings in the old `init.lua`:

1. **Settings/Options**: Copy to `lua/config/settings.lua`
   ```lua
   -- Old:
   vim.opt.number = true
   
   -- New: Still goes in lua/config/settings.lua (same place)
   vim.opt.number = true
   ```

2. **Keybindings**: Copy to appropriate `lua/keymaps/` file
   ```lua
   -- Old:
   vim.keymap.set('n', '<leader>key', function() ... end, { desc = '...' })
   
   -- New: Goes in lua/keymaps/custom.lua or relevant file
   vim.keymap.set('n', '<leader>key', function() ... end, { desc = '...' })
   ```

3. **Plugins**: Create new files in `lua/plugins/`
   ```lua
   -- Old (inline in init.lua):
   {
     'author/plugin-name',
     config = function() ... end,
   }
   
   -- New (in lua/plugins/my-plugin.lua):
   return {
     'author/plugin-name',
     config = function() ... end,
   }
   ```

4. **User Plugins**: Place in `lua/custom/plugins/init.lua`
   ```lua
   return {
     { import = 'custom.plugins' },
   }
   ```

### Benefits of the New Structure

- ✅ **Easy navigation** - Find what you need quickly
- ✅ **Reduced complexity** - Each file is focused and small
- ✅ **Better performance** - Lazy loading and deferred initialization
- ✅ **Easier debugging** - Issues are isolated to specific modules
- ✅ **Scalability** - Add features without touching existing code
- ✅ **Maintainability** - Clear structure and responsibilities

## Quick Reference

| Task | File | Example |
|------|------|---------|
| Change editor option | `lua/config/settings.lua` | `vim.opt.number = true` |
| Add platform-specific code | `lua/config/platform.lua` | Shell config for Windows/Unix |
| Add auto-command | `lua/config/autocmds.lua` | Text yank highlighting |
| Add navigation keybinding | `lua/keymaps/core.lua` | Window movement, buffer nav |
| Add LSP keybinding | `lua/keymaps/diagnostics.lua` | Go to definition, code actions |
| Add custom keybinding | `lua/keymaps/custom.lua` | Personal project shortcuts |
| Add new plugin | Create `lua/plugins/name.lua` | Return lazy.nvim spec |
| User plugin override | `lua/custom/plugins/init.lua` | Custom plugin specs |
| Bootstrap Lua/Vim on start | `init.lua` | Very rarely - prefer modules |

## Keybindings Reference

### Git Keybindings (from diffview.nvim)
- `<leader>gd` - Open diff view for current changes
- `<leader>gh` - Open file history
- `<leader>gc` - Close diff view

### Undo/Redo Keybindings (from undotree.nvim)
- `<leader>u` - Toggle undo tree panel (visualize undo history)

### File Management Keybindings
- `<leader>cf` - Copy file to OS clipboard (from file-copy plugin)

---

**Last Updated**: 2024  
**Configuration Type**: Modular NeoVim (lazy.nvim)  
**Target Users**: NeoVim beginners and experienced users
