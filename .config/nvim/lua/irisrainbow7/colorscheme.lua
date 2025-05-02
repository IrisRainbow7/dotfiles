--vim.cmd.colorscheme 'zephyr'

--require('irisrainbow7/desert')
vim.o.syntax = 'on'


-- fidget.nvim
vim.cmd('highlight FidgetTitle guifg=#b0c4de')
vim.cmd('highlight FidgetTask guifg=#b0c4de')


-- 背景を透過
vim.cmd('highlight Normal ctermbg=NONE guibg=NONE')
vim.cmd('highlight NonText ctermbg=NONE guibg=NONE')
vim.cmd('highlight SpecialKey ctermbg=NONE guibg=NONE')
vim.cmd('highlight EndOfBuffer ctermbg=NONE guibg=NONE')
vim.cmd('highlight SignColumn ctermbg=NONE guibg=NONE')

vim.cmd('highlight NvimBuild ctermfg=235 ctermbg=176 guifg=#2b2d3a guibg=#d38aea')
