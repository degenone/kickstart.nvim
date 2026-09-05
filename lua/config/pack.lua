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
  vim.pack.add(M.specs, { confirm = false, load = false })
end

return M
