require('gitsigns').setup {
signs = {
  add          = { text = '│' },
  change       = { text = '│' },
  delete       = { text = '_' },
  topdelete    = { text = '‾' },
  changedelete = { text = '~' },
  untracked    = { text = '┆' },
},
signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
watch_gitdir = {
  follow_files = true
},
attach_to_untracked = true,
current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
current_line_blame_opts = {
  virt_text = true,
  virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
  delay = 1000,
  ignore_whitespace = false,
},
current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
sign_priority = 6,
update_debounce = 100,
status_formatter = nil, -- Use default
max_file_length = 40000, -- Disable if file is longer than this (in lines)
preview_config = {
  -- Options passed to nvim_open_win
  border = 'single',
  style = 'minimal',
  relative = 'cursor',
  row = 0,
  col = 1
},
yadm = {
  enable = false
},
on_attach = function(bufnr)
  local gs = package.loaded.gitsigns

  local function map(mode, l, r, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, l, r, opts)
  end

  -- Navigation
  map('n', ']c',
    function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end,
    { expr=true, desc = 'gitsigns next hunk' }
  )

  map('n', '[c',
    function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end,
    { expr=true, desc = 'gitsigns prev hunk' }
  )

    map('n', '<leader>hs', gs.stage_hunk, {desc = 'カーソル下の変更をadd'})
    map('n', '<leader>hr', gs.reset_hunk, {desc = 'カーソル下の変更をrestore'})
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = '選択範囲の変更をadd'})
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = '選択範囲の変更をrestore'})
    map('n', '<leader>hS', gs.stage_buffer, {desc = 'ファイル全体の変更をadd'})
    map('n', '<leader>hu', gs.undo_stage_hunk, {desc = '直前のaddを取り消し'})
    map('n', '<leader>hR', gs.reset_buffer, {desc = 'ファイル全体のaddを取り消し'})
    map('n', '<leader>hp', gs.preview_hunk, {desc = '変更をプレビュー'})
    map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc = 'カーソル行のblameを表示'})
    map('n', '<leader>hd', gs.diffthis, {desc = 'git diffを表示'})
    map('n', '<leader>hD', function() gs.diffthis('~') end, {desc = '最新コミットとのdiffを表示'})
    map('n', '<leader>hc', gs.toggle_deleted, {desc = '変更前の表示を切り替え'})

  -- Text object
  map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
end
}
