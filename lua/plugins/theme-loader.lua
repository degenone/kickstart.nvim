-- Theme loader with keybindings to switch between themes

return {
  'nvim-lua/plenary.nvim', -- Required for the theme switcher
  lazy = false,
  priority = 999,
  config = function()
    -- Available themes
    local themes = {
      { name = 'vscode', display = 'VS Code' },
      { name = 'tokyonight-night', display = 'Tokyo Night' },
      { name = 'gruvbox', display = 'Gruvbox' },
      { name = 'catppuccin-mocha', display = 'Catppuccin' },
      { name = 'dracula', display = 'Dracula' },
    }

    -- Function to switch theme
    local function switch_theme(theme_name)
      vim.cmd.colorscheme(theme_name)
      -- Save to a file so it persists across sessions
      local theme_file = vim.fn.stdpath 'config' .. '/.last_theme'
      local file = io.open(theme_file, 'w')
      if file then
        file:write(theme_name)
        file:close()
      end
      vim.notify('Switched to ' .. theme_name, vim.log.levels.INFO)
    end

    -- Load last theme or default to vscode
    local theme_file = vim.fn.stdpath 'config' .. '/.last_theme'
    local file = io.open(theme_file, 'r')
    if file then
      local last_theme = file:read '*line'
      file:close()
      if last_theme and last_theme ~= '' then
        -- Use schedule to ensure all plugins are loaded
        vim.schedule(function()
          local ok = pcall(vim.cmd.colorscheme, last_theme)
          if not ok then
            vim.cmd.colorscheme 'vscode'
          end
        end)
      else
        vim.cmd.colorscheme 'vscode'
      end
    else
      vim.cmd.colorscheme 'vscode'
    end

    -- Create a Telescope picker for theme switching (compact dropdown)
    local function theme_picker()
      local pickers = require 'telescope.pickers'
      local finders = require 'telescope.finders'
      local conf = require('telescope.config').values
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'
      local telescope_themes = require 'telescope.themes'

      pickers
        .new(
          telescope_themes.get_dropdown {
            winblend = 10,
            prompt_title = 'Theme',
            previewer = false,
            layout_config = {
              width = 30,
              height = 8,
            },
          },
          {
            finder = finders.new_table {
              results = themes,
              entry_maker = function(entry)
                return {
                  value = entry.name,
                  display = entry.display,
                  ordinal = entry.display,
                }
              end,
            },
            sorter = conf.generic_sorter {},
            attach_mappings = function(prompt_bufnr, map)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                switch_theme(selection.value)
              end)
              return true
            end,
          }
        )
        :find()
    end

    vim.keymap.set('n', '<leader>ts', theme_picker, { desc = '[T]heme: [S]elect' })
  end,
}
