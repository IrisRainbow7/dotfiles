-- plugins(lazy.nvim)

local function override_keymap_desc(key, mode, desc)
  local map = vim.fn.maparg(key, mode, false, true)
  map.desc = desc
  if map.lhs ~= nil then
    vim.fn.mapset(mode, false, map)
  end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {'rhysd/clever-f.vim', event = 'InsertEnter'},
  {'vim-jp/vimdoc-ja', event = 'CmdlineEnter'},
  {'sheerun/vim-polyglot', event = 'BufEnter'},
  {'bronson/vim-trailing-whitespace', event = {'BufRead', 'BufNewFile'}},
  {'nvim-tree/nvim-web-devicons', event = 'VeryLazy' },
  {'nvim-lua/plenary.nvim', event = 'VeryLazy'},
  {'sindrets/diffview.nvim',
    lazy = true,
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      {'<Plug>@DiffviewOpen', ':DiffviewOpen<CR>', desc = '@ git diff を表示 引数にHEAD~2など指定可能'},
      {'<Plug>@DiffviewFileHistory', ':DiffviewFileHistory %<CR>', desc = '@ git 現在開いているファイルの変更履歴 blame 表示'}
    }
  },
  {'Wansmer/treesj',
    lazy = true,
    event = 'InsertEnter',
    cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
    keys = {
      {'<Leader>s', ':TSJToggle<CR>', silent = true, desc = '@ treesj toggle カーソル下のノードの分割/結合を切り替え'}
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 300
    }
  },
  {'https://github.com/atusy/treemonkey.nvim',
    lazy = true,
    init = function()
      vim.keymap.set({"x", "o"}, "m", function()
        require("treemonkey").select({ ignore_injections = false })
      end)
    end
  },
  {'JoosepAlviste/nvim-ts-context-commentstring',
    event = 'CursorHold',
  },
  {'akinsho/toggleterm.nvim',
    cmd = 'ToggleTerm',
    version = "*",
    opts = {
      open_mapping = false,
      direction = "horizontal",
    },
    keys = {
      {'<Leader>m', ':ToggleTerm<CR>', silent = true, desc = '@ ToggleTerm'}
    }
  },
  {'nvim-pack/nvim-spectre',
    cmd = 'Spectre',
    keys = {
      {'<Plug>@spectre', ':Spectre<CR>', desc = '@ Spectre (一括置換など)'}
    }
  },
  {'rcarriga/nvim-notify',
    event = 'BufReadPost',
    config = function()
      local notify = require('notify')
      notify.setup({
        background_colour = "#000000",
      })
      vim.notify = notify
    end
  },
  {'thinca/vim-quickrun',
    cmd = 'QuickRun',
    keys = {
      {'<F5>', ':QuickRun -mode n<CR>', silent = true, desc = '@ Quickrun(ファイル全体)'},
      {'<F5>', ':QuickRun -mode v<CR>', silent = true, desc = '@ Quickrun(選択範囲)'}
    }
  },
  {'sainnhe/edge',
    lazy = true,
    init = function()
      vim.g.edge_style = 'neon'
      vim.g.edge_enable_italic = 1
      vim.g.edge_transparent_background = 2
      vim.g.edge_better_performance = 1
      vim.cmd.colorscheme 'edge'
    end
  },
  {'lukas-reineke/indent-blankline.nvim',
    event = {'BufRead', 'BufNewFile'},
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
      }
    }
  },
  {'phaazon/hop.nvim',
    cmd = {'HopWord', 'HopChar1', 'HopChar2' },
    branch = 'v2',
    config = true,
    keys = {
      {'<Leader>H', ':HopChar1<CR>', desc = '@ HopChar1'},
      {'<Leader><Leader>', ':HopWord<CR>', desc = '@ HopWord'},
    }
  },
  {'folke/which-key.nvim',
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
    end,
    config = function ()
      require('irisrainbow7/plugins/which-key')
    end
  },
  {'folke/todo-comments.nvim',
    event = 'BufEnter',
    opts = {
      highlight = {
        keyword = 'bg'
      }
    },
  },
  {'tyru/open-browser-github.vim',
    cmd = {'OpenGithubFile', 'OpenGithubProject'},
    dependencies = {'tyru/open-browser.vim'},
    keys = {
      {'<Plug>@OpenGithubFile', ':OpenGithubFile<CR>', desc = '@ ブラウザでこのファイルのgithubページを開く'},
      {'<Plug>@OpenGithubProject', ':OpenGithubProject<CR>', desc = '@ ブラウザでこのプロジェクトのgithubページを開く'},
    }
  },
  {'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
      require('irisrainbow7/plugins/lualine')
    end
  },
  {'kylechui/nvim-surround',
    event = 'InsertEnter',
    version = "*",
    config = true
  },
  {'numToStr/Comment.nvim',
    event = 'InsertEnter',
    config = function()
      require('Comment').setup()
      override_keymap_desc('gc', 'n', '行コメント切り替え')
      override_keymap_desc('gb', 'n', 'ブロックコメント切り替え')
      override_keymap_desc('gcc', 'n', 'カーソル行のコメント切り替え')
      override_keymap_desc('gbc', 'n', 'カーソルブロックのコメント切り替え')
      override_keymap_desc('gc0', 'n', '上にコメント行を追加')
      override_keymap_desc('gco', 'n', '下にコメント行を追加')
      override_keymap_desc('gcA', 'n', '行末にコメントを追加')
    end,
    keys = {
      {'<Plug>@commentlinetoggle', ':normal gcc<CR>', desc = '@ 行コメント切り替え', silent = true},
      {'<Plug>@commentblocktoggle', ':normal gbc<CR>', desc = '@ ブロックコメント切り替え', silent = true},
      {'<Plug>@commentabovelineadd', ':normal gc0<CR>', desc = '@ 上にコメント行を追加', silent = true},
      {'<Plug>@commentbelowlineadd', ':normal gco<CR>', desc = '@ 下にコメント行を追加', silent = true},
      {'<Plug>@commentendoflineadd', ':normal gcA<CR>', desc = '@ 行末にコメントを追加', silent = true},
  }
  },
  {'nvim-treesitter/nvim-treesitter',
    lazy = true,
    event = "BufReadPost",
    build = function()
      if #vim.api.nvim_list_uis() ~= 0 then
        vim.api.nvim_command("TSUpdate")
      end
	end,
    dependencies = {
      {'windwp/nvim-ts-autotag'},
      {'nvim-treesitter/nvim-treesitter-textobjects'},
      {'nvim-treesitter/playground',
        keys = {
          {'<Plug>@treesitterplaygroundinspect', ':Inspect<CR>', desc = '@ treesitter playground inspect カーソル下のハイライトグループを表示'},
          {'<Plug>@treesitterplaygroundinspecttree', ':InspectTree<CR>', desc = '@ treesitter playground を開いてカーソル下の要素にカーソル移動'},
          {'<Plug>@treesitterplaygroundtoggle', ':TSPlaygroundToggle<CR>', desc = '@ treesitter playground を開く'},
        }
      },
    },
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {'lua', 'vim', 'vimdoc', 'vue', 'javascript', 'typescript', 'ruby', 'markdown', 'markdown_inline', 'query', 'html', 'python', 'yaml', 'bash', 'dockerfile','gitcommit', 'gitignore', 'json', 'scss', 'css', 'sql', 'tsx', 'rust', 'pug', 'make'},
        sync_install = true,
        auto_install = true,
        highlight = { enable = true },
        playground = {
            enable = true,
            disable = {},
            updatetime = 25,
            persist_queries = false,
            keybindings = {
              toggle_query_editor = 'o',
              toggle_hl_groups = 'i',
              toggle_injected_languages = 't',
              toggle_anonymous_nodes = 'a',
              toggle_language_display = 'I',
              focus_language = 'f',
              unfocus_language = 'F',
              update = 'R',
              goto_node = '<cr>',
              show_help = '?',
            },
        },
        textobjects = {
			select = {
				enable = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]["] = "@function.outer",
					["]m"] = "@class.outer",
				},
				goto_next_end = {
					["]]"] = "@function.outer",
					["]M"] = "@class.outer",
				},
				goto_previous_start = {
					["[["] = "@function.outer",
					["[m"] = "@class.outer",
				},
				goto_previous_end = {
					["[]"] = "@function.outer",
					["[M"] = "@class.outer",
				},
			},
		},
		context_commentstring = { enable = true, enable_autocmd = false },
		indent = { enable = true },
        autotag = { enable = true },
        matchup = { enable = true },
      }
    end
  },
  {'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    dependencies = {
      'kkharji/sqlite.lua',
      'xiyaowong/telescope-emoji.nvim',
      'piersolenski/telescope-import.nvim',
      'IrisRainbow7/telescope-lsp-server-capabilities.nvim',
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup {
        defaults = {
          dynamic_preview_title = true,
          mappings = {
            i = {
              ['<esc>'] = require('telescope.actions').close
            }
          },
        },
        extensions = {
        }
      }
      telescope.load_extension("notify")
      telescope.load_extension("emoji")
      telescope.load_extension("import")
      telescope.load_extension("lsp_server_capabilities")
      for k, v in pairs(require('telescope.builtin')) do
        if type(v) == "function" then
          vim.keymap.set('n', '<Plug>(telescope.' .. k .. ')', v, { desc = '@ telescope ' .. k })
        end
      end
      vim.keymap.set('n', '<Plug>(telescope.notify)', ':Telescope notify<CR>', { desc = '@ telescope notify' })
      vim.keymap.set('n', '<Plug>(telescope.emoji)', ':Telescope emoji<CR>', { desc = '@ telescope emoji' })
      vim.keymap.set('n', '<Plug>(telescope.import)', ':Telescope import<CR>', { desc = '@ telescope import' })
      vim.keymap.set('n', '<Plug>(telescope.lsp_server_capabilities)', ':Telescope lsp_server_capabilities<CR>', { desc = '@ telescope lsp_server_capabilities' })
    end,
    keys = {
      { '<C-p>', ':Telescope find_files<CR>', desc = '@ Telescope find_files'},
      { '<Leader>f', ':Telescope find_files<CR>', desc = '@ Telescope find_files'},
      { '<Leader>l', ':Telescope live_grep<CR>', desc = '@ Telescope live_grep'},
      { '<Leader>b', ':Telescope buffers<CR>', desc = '@ Telescope buffers'},
      {
        '<Leader>k',
        function()
          require('telescope.builtin').keymaps()
          vim.cmd("normal! i@")
        end,
        desc = 'Telescope keymaps @ コマンドパレット'
      },
      {'<Plug>@telescope notify', ':Telescope notify<CR>', desc = '@ 通知履歴'},
    }
  },
  {'goolord/alpha-nvim',
    lazy = false,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      local alpha = require'alpha'
      alpha.setup(require'irisrainbow7/plugins/alpha-nvim'.config)
    end
  },
  {'nvim-tree/nvim-tree.lua',
    cmd = {'NvimTreeOpen','NvimTreeToggle', 'NvimTreeFocus', 'NvimTreeFindFile', 'NvimTreeCollapse'},
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    keys = {
      { '<Leader>t', ':NvimTreeFindFileToggle<CR>', desc = '@ NvimTreeFindFileToggle' }
    },
    opts = {
      disable_netrw = true,
      renderer = {
        highlight_opened_files = 'all',
        highlight_modified = 'all'
      },
      modified = {
        enable = true
      }
    }
  },
  {'petertriho/nvim-scrollbar',
    event = {'CursorHold', 'CursorHoldI'},
    dependencies = {
      {'kevinhwang91/nvim-hlslens',
        config = true,
      },
      {'lewis6991/gitsigns.nvim',
        config = function ()
          require('irisrainbow7/plugins/gitsigns')
        end,
        keys = {
          { '<Plug>@gitsignstogglesigns', ':Gitsigns toggle_signs<CR>', desc = '@ Gitsigns sign表示切り替え' },
          { '<Plug>@gitsignstogglenumhl', ':Gitsigns toggle_numhl<CR>', desc = '@ Gitsigns 行数ハイライト表示切り替え' },
          { '<Plug>@gitsignstogglelinehl', ':Gitsigns toggle_linehl<CR>', desc = '@ Gitsigns 行ハイライト表示切り替え' },
          { '<Plug>@gitsignstoggleworddiff', ':Gitsigns toggle_word_diff<CR>', desc = '@ Gitsigns 単語ハイライト表示切り替え' },
          { '<Plug>@gitsignstogglecurrentlineblame', ':Gitsigns toggle_current_line_blame<CR>', desc = '@ Gitsigns toggle_current_line_blame' },
        }
      }
    },
    config = function ()
      require('scrollbar').setup({
          handle = {
            color = '#292e42',
          },
        })
      require('scrollbar.handlers.search').setup()
      require("scrollbar.handlers.gitsigns").setup()
    end
  },
  {'andymass/vim-matchup',
    event = 'InsertEnter',
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end
  },
  {'RRethy/nvim-treesitter-endwise',
    event = 'InsertEnter',
    config = function ()
      require('nvim-treesitter.configs').setup {
        endwise = {
          enable = true,
        },
      }
    end
  },
  {'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true
  },
  {'ethanholz/nvim-lastplace',
    event = 'VeryLazy',
    config = true
  },
  {'norcalli/nvim-colorizer.lua',
    event = {'BufRead', 'BufNewFile'},
    config = function()
      require('colorizer').setup()
    end
  },
  {'dinhhuy258/git.nvim',
    cmd = {'Git', 'GitBlame', 'GitDiff', 'GitCreatePullRequest', 'GitRevert', 'GitRevertFile'},
    event = 'InsertEnter',
    config = function ()
      require('git').setup()
    end,
    keys = {
      {'<Plug>@gitcommand', ':Git<CR>', desc = '@ Gitコマンドを実行'},
      {'<Plug>@gitblame', ':GitBlame<CR>', desc = '@ git blame'},
      {'<Plug>@gitdiff', ':GitDiff<CR>', desc = '@ git diff'},
      {'<Plug>@gitcreatepullrequest', ':GitCreatePullRequest<CR>', desc = '@ git pull request を作成する画面を開く'},
      {'<Plug>@gitrevert', ':GitRevert<CR>', desc = '@ git revert'},
      {'<Plug>@gitrevertfile', ':GitRevertFile<CR>', desc = '@ 現在のファイルをgit revert'},
    }
  },
  {'akinsho/git-conflict.nvim',
    event = 'BufRead',
    config = function()
      require('git-conflict').setup()
    end
  },
  -----------
  {'neovim/nvim-lspconfig',
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    dependencies = {
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      {'ray-x/lsp_signature.nvim',
        opts = {
          hint_enable = false,
        },
      }
    },
    config = function ()
      require('mason').setup()
      require("mason-lspconfig").setup()
      local rubylspconfig = require 'irisrainbow7/lsp/ruby-lsp'
      require('mason-lspconfig').setup_handlers {
        function(server_name)
          require('lspconfig')[server_name].setup {
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
          }
        end,
        ['ruby_ls'] = function()
          require('lspconfig').ruby_ls.setup({
            on_attach = function(client, buffer)
              rubylspconfig.setup_diagnostics(client, buffer)
            end,
          })
        end,
        ['lua_ls'] = function()
          local lualsconfig = require 'irisrainbow7/lsp/lua_ls'
          require('lspconfig').lua_ls.setup(lualsconfig)
        end
      }
      vim.api.nvim_command([[LspStart]])
    end
  },
  {'hrsh7th/nvim-cmp',
    event = {'InsertEnter', 'CmdlineEnter'},
    config = function()
      require 'irisrainbow7/plugins/nvim-cmp'
    end,
    dependencies = {
      {'L3MON4D3/LuaSnip',
        version = "v2.*",
        build = 'make install_jsregexp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function ()
          require("luasnip.loaders.from_vscode").lazy_load()
        end
      },
      {'hrsh7th/cmp-path'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-cmdline'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-nvim-lua'},
      {'saadparwaiz1/cmp_luasnip'},
    }
  },
  {'nvimtools/none-ls.nvim',
    lazy = true,
    event = { "CursorHold", "CursorHoldI" },
    config = function ()
      local null_ls = require('null-ls')
      null_ls.setup {
        sources = {
          null_ls.builtins.diagnostics.selene,
          null_ls.builtins.code_actions.gitrebase,
          null_ls.builtins.formatting.stylua
        }
      }
    end
  },
  {'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {
      notification = {
        filter = vim.log.levels.TRACE,
        window = {
          winblend = 0,
        }
      }
    }
  },
  {'folke/trouble.nvim',
    event = 'LspAttach',
    keys = {
      {'<Leader>d', ':TroubleToggle document_diagnostics<CR>', desc = '@ TroubleToggle document_diagnostics'}
    },
    opts = {}
  },
  {'dnlhc/glance.nvim',
    event = 'LspAttach',
    opts = {
      border = {
        enable = true,
        top_char = '┉',
        bottom_char = '┉',
      },
    },
    keys = {
      {'<Plug>@glancereferences', ':Glance references<CR>', desc = '@ glance references'},
      {'<Plug>@glancedefinitions', ':Glance definitions<CR>', desc = '@ glance definitions 定義一覧'},
      {'<Plug>@glancetype_definitions', ':Glance type_definitions<CR>', desc = '@ glance type_definitions 型定義一覧'},
      {'<Plug>@glanceimplementations', ':Glance implementations<CR>', desc = '@ glance implementations'},
    }
  },
  {'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    opts = {
      border_style = "single",
      lightbulb = {
        enable = false,
      },
    },
    keys = {
      {'<Plug>@lspsagaoutline', ':Lspsaga outline', desc = '@ Lspsaga outline'}
    }
  },
  {'onsails/lspkind.nvim', event = 'LspAttach'}
},
{
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    }
  }
}
)


vim.api.nvim_create_autocmd('VimEnter', {
    callback = function ()
      require('nvim-lastplace').lastplace_ft(0)
    end
})

vim.api.nvim_create_user_command(
  'Ve',
  function ()
    local api = require("nvim-tree.api")
    local halfWidth = vim.fn.winwidth(0) / 2 - 5
    api.tree.find_file { open = true, focus = true, update_root = false }
    vim.cmd('vertical resize ' .. halfWidth)
    vim.keymap.set('n', '<CR>', api.node.open.replace_tree_buffer, { desc = 'nvim-tree: Open: In Place', buffer = 0, noremap = true, silent = true, nowait = true })
  end,
  {}
)
vim.keymap.set('n', '<Plug>@verticalsplitnvimtreefindfile', ':Ve<CR>', {desc = '@ 画面を縦に2分割して左画面でnvimtreeのfindfileを開く'})
