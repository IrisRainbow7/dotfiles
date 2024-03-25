local wk = require("which-key")

wk.setup({
    triggers_nowait = {
      -- marks
      "`",
      "'",
      "g`",
      "g'",
      -- registers
      '"',
      "<c-r>",
      -- spelling
      "z=",
      '<Leader>',
    },
})

wk.register({
    g = "@ 定義ジャンプ",
    h = "@ gitsigns",
}, { prefix = "<leader>" })

wk.register({
    ["<C-p>"] = "Telescope find_files",
    ["<C-k>"] = "lsp signature_help",
    ys = "括弧を追加(normalモード)",
    yS = "括弧を改行して追加(normalモード)",
    cs = "括弧を変更",
    cS = "括弧を改行して変更",
    ds = "括弧を削除",
    zo = "カーソル下の折りたたみを開く",
    zc = "カーソル下の折りたたみを閉じる",
    za = "カーソル下の折りたたみを切り替え",
})

wk.register({
    zf = "選択範囲を折りたたむ"
}, { mode = "v" })


vim.keymap.set('n', '<Plug>@fold', ':normal za<CR>', { desc = '@ fold toggle カーソル下の折りたたみを切り替え' })
