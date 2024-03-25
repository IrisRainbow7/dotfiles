-- keymaps

vim.api.nvim_set_var('mapleader', '\\')

-- 矢印キーで画面上の１行単位で移動するように
vim.keymap.set('n', '<Up>', 'gk')
vim.keymap.set('n', '<Down>', 'gj')

-- Shift + 矢印キーでウィンドウサイズ変更
vim.keymap.set('n', '<S-Left>', '<C-w><<CR>')
vim.keymap.set('n', '<S-Right>', '<C-w>><CR>')
vim.keymap.set('n', '<S-Up>', '<C-w>-<CR>')
vim.keymap.set('n', '<S-Down>', '<C-w>+<CR>')

-- jjでESC
vim.keymap.set('i', 'jj', '<ESC>', { silent = true })

-- 誤字修正
vim.cmd.abbreviate('appned', 'append')

-- C-tで次のQuickfix
vim.keymap.set('n', '<C-t>', ':cn<CR>', { silent = true, desc = '@ 次のQuickfix' })

-- insertモード中の矢印キーでUndoブロックを途切れさせない
vim.keymap.set('i', '<Left>', '<C-G>U<Left>')
vim.keymap.set('i', '<Right>', '<C-G>U<Right>')

-- tab next/prev
vim.keymap.set('n', '<Leader><Right>', ':tabnext<CR><C-G>', { desc = '@ 次のタブ next tab' })
vim.keymap.set('n', '<Leader><Left>', ':tabprevious<CR><C-G>', { desc = '@ 前のタブ prev tab' })
vim.keymap.set('n', '<C-Right>', ':tabnext<CR><C-G>', { desc = '@ 次のタブ next tab' })
vim.keymap.set('n', '<C-Left>', ':tabprevious<CR><C-G>', { desc = '@ 前のタブ prev tab' })

-- whichkey
vim.keymap.set('n', '<F1>', ':WhichKey<CR>', { desc = '@ WhichKey' })

-- x blackhole register
vim.keymap.set({ 'n', 'v' }, 'x', '"_x', { desc = 'x with blackhole register' })
vim.keymap.set({ 'n', 'v' }, 'X', '"_X', { desc = 'X with blackhole register' })

-- increment & decrement (-) (+)
vim.keymap.set({'n', 'v'}, '+', '<C-a>', { desc = 'インクリメント increment' })
vim.keymap.set({'n', 'v'}, '-', '<C-x>', { desc = 'デクリメント decrement' })

-- terminal
vim.keymap.set('n', '<C-\\>', ':ToggleTerm<CR>', { desc = '@ ToggleTerm' })
vim.keymap.set('i', '<C-\\>', '<ESC>:ToggleTerm<CR>', { desc = '@ ToggleTerm' })
vim.keymap.set('t', '<C-\\>', '<C-\\><C-n>:ToggleTerm<CR>', { desc = '@ ToggleTerm' })
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', { silent = true })
vim.keymap.set('t', '<C-w><Down>', ':wincmd j', { silent = true })
vim.keymap.set('t', '<C-w><Up>', ':wincmd k', { silent = true })
vim.keymap.set('t', '<C-w><Left>', ':wincmd h', { silent = true })
vim.keymap.set('t', '<C-w><Right>', ':wincmd l', { silent = true })
vim.keymap.set('t', '<C-w>j', ':wincmd j', { silent = true })
vim.keymap.set('t', '<C-w>k', ':wincmd k', { silent = true })
vim.keymap.set('t', '<C-w>h', ':wincmd h', { silent = true })
vim.keymap.set('t', '<C-w>l', ':wincmd l', { silent = true })
vim.keymap.set('t', '<C-w><C-j>', ':wincmd j', { silent = true })
vim.keymap.set('t', '<C-w><C-k>', ':wincmd k', { silent = true })
vim.keymap.set('t', '<C-w><C-h>', ':wincmd h', { silent = true })
vim.keymap.set('t', '<C-w><C-l>', ':wincmd l', { silent = true })
vim.keymap.set('t', '<C-w><C-q>', ':quit<CR>', { silent = true })
vim.keymap.set('t', '<C-w>q', ':quit<CR>', { silent = true })

-- "*" を押した時次の候補に飛ばない
vim.keymap.set('n', '*', function()
	if vim.v.count > 0 then
		return '*'
	else
		return ':silent execute "keepj norm! *" <Bar> call winrestview(' ..
		vim.fn.string(vim.fn.winsaveview()) .. ')<CR>'
	end
end, { silent = true, expr = true })


------------------------------------------------------------------------------------------------------------

--nvim-lsp-config
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, { desc = '@ diagnosticをfloatで表示' })
vim.keymap.set('n', '[d', ':Lspsaga diagnostic_jump_next<CR>', { silent = true, desc = '@ 次のdiagnostic' })
vim.keymap.set('n', ']d', ':Lspsaga diagnostic_jump_prev<CR>', { silent = true, desc = '@ 前のdiagnostic' })

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local function opts(desc)
      return { desc = '@ ' .. desc, buffer = ev.buf, silent = true }
    end
    vim.keymap.set('n', 'gd', ':Lspsaga peek_definition<CR>', opts('lspsaga 定義を表示'))
    vim.keymap.set('n', 'gD', ':Lspsaga peek_type_definition<CR>', opts('lspsaga 型定義を表示'))
    vim.keymap.set('n', '<Leader>gd', ':Lspsaga goto_definition<CR>', opts('lspsaga 定義にジャンプ'))
    vim.keymap.set('n', '<Leader>gD', ':Lspsaga goto_type_definition<CR>', opts('lspsaga 型定義にジャンプ'))
    vim.keymap.set('n', 'K', ':Lspsaga hover_doc<CR>', opts('lspsaga ドキュメントを表示'))
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts('signature help'))
    vim.keymap.set('n', '<Leader>re', ':Lspsaga rename<CR>', opts('lspsaga 一括リネーム'))
    vim.keymap.set({ 'n', 'v' }, '<Leader>c', ':Lspsaga code_action<CR>', opts('lspsaga コードアクションを表示'))
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts('使用箇所を表示'))
    vim.keymap.set('n', '<leader>o', vim.lsp.buf.format, opts('lsp 開いているファイルをフォーマット'))
    vim.keymap.set('n', '<leader>i', ':Lspsaga finder<CR>', opts('Lspsaga finder'))
    vim.keymap.set('n', '<leader>w', ':Lspsaga show_workspace_diagnostics<CR>', opts('lspsaga workspaceのdiagnosticsを表示'))
  end,
})
