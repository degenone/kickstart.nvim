return {
  'rest-nvim/rest.nvim',
  ft = { 'http' },
  cmd = { 'Rest' },
  dependencies = {
    'nvim-neotest/nvim-nio',
    'j-hui/fidget.nvim',
  },
  config = function()
    vim.g.rest_nvim = {
      request = {
        skip_ssl_verification = false,
      },
      response = {
        hooks = {
          format = true,
        },
      },
    }
  end,
}
