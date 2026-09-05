# Neovim configuration guide

This is a modular Neovim configuration using the native `vim.pack` package
manager. It targets the current stable version of Neovim on Windows, macOS, and
Linux.

## Layout

```text
nvim/
├── init.lua                 # Startup order and global settings
├── nvim-pack-lock.json      # Reproducible plugin revisions
├── lua/
│   ├── config/
│   │   ├── pack.lua          # vim.pack manifest, builds, and commands
│   │   ├── platform.lua      # Windows/macOS/Linux differences
│   │   ├── settings.lua      # Editor options
│   │   └── autocmds.lua      # Autocommands
│   ├── keymaps/              # Core, diagnostic, and custom mappings
│   ├── plugins/              # One configuration module per plugin
│   └── custom/               # Personal modules and optional local plugins
└── doc/
    └── WORKFLOWS.md          # REST and DAP usage reference
```

Startup order is:

```text
init.lua
├─ config.platform            # Shell, Python, and LuaRocks paths
├─ config.pack                # Install/load packages and configure plugins
├─ config                     # Settings and autocommands
└─ keymaps                    # Editor and diagnostic mappings
```

## Plugin management

The manifest is `lua/config/pack.lua`. Add a Git source there with the helper:

```lua
github('author/plugin-name')
```

Then create `lua/plugins/plugin-name.lua` with its setup. Plugin modules return
a configuration table in the existing format:

```lua
return {
  'author/plugin-name',
  dependencies = { 'other/plugin' },
  opts = {},
  config = function()
    require('plugin-name').setup {}
  end,
  keys = {
    { '<leader>x', '<cmd>Example<CR>', desc = 'Example action' },
  },
}
```

`config.pack` currently loads the manifest eagerly and then applies each
module's `config`, `opts`, and `keys`. Fields such as `event`, `ft`, `cmd`,
`lazy`, `cond`, and `build` are legacy lazy.nvim metadata; they do not provide
native lazy loading or build hooks. Prefer explicit commands/autocommands in
`config.pack` when adding those behaviours.

Useful commands:

| Command | Purpose |
| --- | --- |
| `:PackUpdate` | Review and apply available plugin updates |
| `:PackBuild` | Build all supported native dependencies |
| `:PackBuild fzf` | Build Telescope's FZF extension only |
| `:lua vim.pack.get()` | Inspect installed/active packages |

`nvim-pack-lock.json` records exact revisions. Commit it with configuration
changes. After `:PackUpdate`, review and commit the lockfile if the updates are
intentional. A new machine installs the locked revisions on its first startup.

The FZF extension uses CMake and a C compiler. If it is unavailable, Telescope
continues to work without native FZF matching; install the build tools and run
`:PackBuild fzf` to enable it. LuaSnip's optional `jsregexp` component is not
built by this setup.

## Platform notes

`config.platform` configures PowerShell on Windows, finds `python3` on Unix,
and adds user LuaRocks locations for REST's optional XML and external-body
support. It checks both Lua 5.1 and 5.5 rock paths.

The usual external tools are checked by `:checkhealth kickstart.nvim`:
`git`, `make`, `unzip`, `rg`, `curl`, `node`, `npm`, `dotnet`, `prettier`,
`luarocks`, and `cmake`.

Personal local plugins are deliberately optional. To enable the local
`code_assistant` plugin on a machine that has it, set `NVIM_CODE_ASSISTANT_DIR`
to that plugin's absolute directory before launching Neovim. Windows retains
the existing `D:\\learn-lua\\plugin` location as a fallback. If the selected
directory does not exist, Neovim starts normally without the plugin.

## Where to make changes

| Task | Location |
| --- | --- |
| Editor options | `lua/config/settings.lua` |
| OS-specific behaviour | `lua/config/platform.lua` |
| Autocommands | `lua/config/autocmds.lua` |
| Core mappings | `lua/keymaps/core.lua` |
| Diagnostic mappings | `lua/keymaps/diagnostics.lua` |
| A plugin's setup | `lua/plugins/<name>.lua` |
| Manifest or native build support | `lua/config/pack.lua` |
| Personal local modules | `lua/custom/` |

For REST environments and C# DAP usage, see [WORKFLOWS.md](WORKFLOWS.md).

## Troubleshooting

- Check startup errors with `:messages`.
- Inspect keymap ownership with `:verbose map <key>`.
- Inspect LSP clients with `:checkhealth vim.lsp`.
- Inspect REST dependencies with `:checkhealth rest-nvim`.
- Inspect deprecations with `:checkhealth vim.deprecated`.
- If a package needs a clean reinstall, remove it from the manifest, restart,
  then use `vim.pack.del()` as described in `:help vim.pack`.
