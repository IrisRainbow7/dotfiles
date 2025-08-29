local lsp_servers = {
  'lua_ls',
  'vtsls',
  'vue_ls',
  'eslint',
  'pylsp',
  'ruff',
}

require('mason').setup()
require("mason-lspconfig").setup({
  ensure_installed = lsp_servers,
  automatic_enable = true,
})

vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
