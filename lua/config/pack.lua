local M = {}

local function github(repo, version)
  return {
    src = 'https://github.com/' .. repo,
    version = version,
  }
end

-- Native vim.pack manifest. Loading remains disabled during this first step;
-- Lazy continues to provide the current runtime while the pack tree is built.
M.specs = {
  github('windwp/nvim-autopairs'),
  github('catppuccin/nvim'),
  github('Mofiqul/vscode.nvim'),
  github('hrsh7th/nvim-cmp'),
  github('L3MON4D3/LuaSnip'),
  github('rafamadriz/friendly-snippets'),
  github('saadparwaiz1/cmp_luasnip'),
  github('hrsh7th/cmp-nvim-lsp'),
  github('hrsh7th/cmp-path'),
  github('stevearc/conform.nvim'),
  github('mfussenegger/nvim-dap'),
  github('rcarriga/nvim-dap-ui'),
  github('nvim-neotest/nvim-nio'),
  github('jay-babu/mason-nvim-dap.nvim'),
  github('leoluz/nvim-dap-go'),
  github('dlyongemallo/diffview.nvim'),
  github('Mofiqul/dracula.nvim'),
  github('lewis6991/gitsigns.nvim'),
  github('ellisonleao/gruvbox.nvim'),
  github('NMAC427/guess-indent.nvim'),
  github('lukas-reineke/indent-blankline.nvim'),
  github('folke/lazydev.nvim'),
  github('mfussenegger/nvim-lint'),
  github('neovim/nvim-lspconfig'),
  github('williamboman/mason.nvim'),
  github('williamboman/mason-lspconfig.nvim'),
  github('WhoIsSethDaniel/mason-tool-installer.nvim'),
  github('j-hui/fidget.nvim'),
  github('seblyng/roslyn.nvim'),
  github('echasnovski/mini.nvim'),
  github('nvim-neo-tree/neo-tree.nvim'),
  github('nvim-lua/plenary.nvim'),
  github('nvim-tree/nvim-web-devicons'),
  github('MunifTanjim/nui.nvim'),
  github('rest-nvim/rest.nvim'),
  github('nvim-telescope/telescope.nvim', '0.1.x'),
  github('nvim-telescope/telescope-fzf-native.nvim'),
  github('nvim-telescope/telescope-ui-select.nvim'),
  github('folke/todo-comments.nvim'),
  github('folke/tokyonight.nvim'),
  github('nvim-treesitter/nvim-treesitter', 'main'),
  github('mbbill/undotree'),
  github('tpope/vim-sleuth'),
}

function M.install()
  vim.pack.add(M.specs, { confirm = false, load = true })
end

local plugin_modules = {
  'plugins.autopairs',
  'plugins.catppuccin',
  'plugins.colorscheme',
  'plugins.completion',
  'plugins.conform',
  'plugins.debug',
  'plugins.diffview',
  'plugins.dracula',
  'plugins.gitsigns',
  'plugins.gruvbox',
  'plugins.guess-indent',
  'plugins.indent_line',
  'plugins.lazydev',
  'plugins.lint',
  'plugins.lsp',
  'plugins.mini',
  'plugins.neo-tree',
  'plugins.rest',
  'plugins.telescope',
  'plugins.theme-loader',
  'plugins.todo-comments',
  'plugins.tokyonight',
  'plugins.treesitter',
  'plugins.undotree',
  'plugins.vim-sleuth',
  'custom.plugins.init',
}

local main_modules = {
  ['gitsigns.nvim'] = 'gitsigns',
  ['guess-indent.nvim'] = 'guess-indent',
  ['indent-blankline.nvim'] = 'ibl',
  ['lazydev.nvim'] = 'lazydev',
  ['nvim-neo-tree.nvim'] = 'neo-tree',
  ['conform.nvim'] = 'conform',
  ['todo-comments.nvim'] = 'todo-comments',
  ['fidget.nvim'] = 'fidget',
  ['mason.nvim'] = 'mason',
}

local function plugin_name(spec)
  if type(spec) ~= 'table' or type(spec[1]) ~= 'string' then return nil end
  return spec[1]:match '/([^/]+)$'
end

local function configure_spec(spec, configured)
  if type(spec) ~= 'table' then return end

  -- Some spec files return a list of plugin specs rather than one spec.
  if type(spec[1]) == 'table' then
    for _, child in ipairs(spec) do
      configure_spec(child, configured)
    end
    return
  end

  for _, dependency in ipairs(spec.dependencies or {}) do
    configure_spec(dependency, configured)
  end

  local name = plugin_name(spec)
  if not name or configured[name] then return end
  configured[name] = true

  if type(spec.config) == 'function' then
    spec.config()
  elseif spec.config == true then
    local module = main_modules[name]
    if module then require(module).setup() end
  elseif spec.opts then
    local module = spec.main or main_modules[name]
    if module then require(module).setup(spec.opts) end
  end
end

function M.setup()
  M.install()

  local configured = {}
  for _, module_name in ipairs(plugin_modules) do
    local ok, spec = pcall(require, module_name)
    if not ok then
      error(('Could not load plugin specification %s: %s'):format(module_name, spec))
    end
    if module_name == 'custom.plugins.init' then
      for _, custom_spec in ipairs(spec) do
        if custom_spec.dir and custom_spec.dir ~= vim.fn.stdpath 'config' .. '/lua/custom/modules/file-copy' then
          vim.opt.rtp:prepend(custom_spec.dir)
        end
        if type(custom_spec.config) == 'function' then
          custom_spec.config()
        end
      end
    else
      configure_spec(spec, configured)
    end
  end
end

return M
