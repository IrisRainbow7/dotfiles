local options = {
  encoding = 'utf-8',
  fileencoding = 'utf-8',
  helplang = 'ja',
  showmatch = true,
  ignorecase = true,
  smartcase = true,
  hidden = true,
  number = true,
  expandtab = true,
  tabstop = 4,
  shiftwidth = 4,
  wrapscan = true,
  relativenumber = true,
  updatetime = 200,
  laststatus = 2,
  wildmenu = true,
  hlsearch = true,
  background = 'dark',
  clipboard = 'unnamedplus',
  keywordprg = ':help',
  virtualedit = 'block',
  showmode = false,
  termguicolors = true,
  pumblend = 20,
  backup = true,
  backupdir = os.getenv("HOME") .. '/vimbackup/',
  backupext = '.bak',
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.formatoptions:append 'nmMj'
vim.opt.shortmess:append 'c'

vim.g.python3_host_prog = '/opt/homebrew/bin/python3'
vim.g.skip_ts_context_commentstring_module = true

vim.diagnostic.config({
        virtual_text = {
            format = function(diagnostic)
                return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
            end,
        }
    })

