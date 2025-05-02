local wk = require("which-key")

wk.setup({})

wk.add({
  { "<leader>g", desc="@ 定義ジャンプ" },
  { "<leader>h", desc="@ gitsigns" }
})

wk.add({
  { "<C-p>", desc="Telescope find_files" },
  { "<C-k>", desc="lsp signature_help" },
  { "ys", desc="括弧を追加(normalモード)" },
  { "yS", desc="括弧を改行して追加(normalモード)" },
  { "cs", desc="括弧を変更" },
  { "cS", desc="括弧を改行して変更" },
  { "ds", desc="括弧を削除" },
  { "zo", desc="カーソル下の折りたたみを開く" },
  { "zc", desc="カーソル下の折りたたみを閉じる" },
  { "za", desc="カーソル下の折りたたみを切り替え" },
})

wk.add({
  { "zf", desc="選択範囲を折りたたむ", mode="v" },
  { "<Plug>@fold", ":normal za<CR>", desc="@ fold toggle カーソル下の折りたたみを切り替え", mode="n" }
})
