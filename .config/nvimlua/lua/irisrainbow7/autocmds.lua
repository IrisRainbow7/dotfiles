-- autocmds

-- 全角スペース　可視化
function ZenkakuSpace()
        vim.cmd('highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray')
end
ZenkakuSpace()

vim.api.nvim_create_augroup('ZenkakuSpace', {})
vim.api.nvim_create_autocmd('ColorScheme', {
        group = 'ZenkakuSpace',
        callback = ZenkakuSpace
})
vim.api.nvim_create_autocmd({'VimEnter', 'WinEnter'}, {
        group = 'ZenkakuSpace',
        callback = function()
                vim.fn.matchadd('ZenkakuSpace', '　')
        end
})

-- fileindent
local function setTabStep2()
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.shiftwidth = 2
end

vim.api.nvim_create_augroup('fileTypeIndent', {})
vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
                pattern = {'*.rb', '*.vue', '*.js', '*.ts', '*.html', '*.lua'},
                callback = setTabStep2
        })


-- vimgrep時にQuickfix自動起動
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
                pattern = '*grep*',
                command = 'cwindow'
        })

-- コマンドライン履歴にwxqなどを残さない
vim.api.nvim_create_augroup('deletecommandhistory', {})
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "c:*",
  group = 'deletecommandhistory',
  callback = function()
    local cmd = vim.fn.histget(":", -1)
    if cmd == "x" or cmd == "xa" or cmd:match("^w?q?a?!?$") then
      vim.fn.histdel(":", -1)
    end
  end,
})

-- Quickfixに追加するコマンド
vim.api.nvim_create_user_command("QfAdd", function(opts)
  local filename = vim.fn.expand("%:p")
  local list = {}
  for lnum = opts["line1"], opts["line2"] do
    local text = vim.fn.getline(lnum)
    if vim.fn.trim(text) ~= "" then
      table.insert(list, { filename = filename, lnum = lnum, text = text })
    end
  end
  local action = "a"
  local hidden = false
  for _, arg in pairs(opts.fargs) do
    if arg == "-reset" or arg == "-r" then
      if action ~= " " then
        action = "r"
      end
    elseif arg == "-hidden" or arg == "-h" then
      hidden = true
    elseif arg == "-new" or arg == "-n" then
      action = " "
    end
  end
  vim.fn.setqflist(list, action)
  if not hidden then
    vim.cmd.copen()
  end
end, { force = true, range = true, nargs = "*" })
vim.cmd([[ cabbrev <expr> Qfadd (getcmdtype() ==# ":" && getcmdline() ==# "Qfadd") ? "QfAdd" : "Qfadd" ]])
vim.keymap.set('n', '<Plug>QfAdd', ':QfAdd<CR>', {desc = '@ Quickfix add'})

-- tab数が1の時はtablineを隠す
--[[ vim.api.nvim_create_augroup('tablineswitch', {})
vim.api.nvim_create_autocmd({"TabNew", "TabClosed"}, {
  group = "tablineswitch",
  callback = function()
  end
}) ]]
