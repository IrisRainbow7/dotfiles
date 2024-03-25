vim.api.nvim_create_user_command('Buffers', 'Telescope buffers', {})
vim.api.nvim_create_user_command(
  'Copyfilepath',
  "let @* = expand('%:h') .. '/' .. expand('%:t')",
  {}
)
vim.keymap.set('n', '<Plug>@Copyfilepath', ':Copyfilepath<CR>', {desc = '@ 現在のファイルのpathをコピー'})


