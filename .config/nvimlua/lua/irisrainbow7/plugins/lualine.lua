local diff_source = function()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local function selectionCount()
    local mode = vim.fn.mode()
    local start_line, end_line, start_pos, end_pos

    -- 選択モードでない場合には無効
    if not (mode:find("[vV\22]") ~= nil) then return "" end
    start_line = vim.fn.line("v")
    end_line = vim.fn.line(".")

    if mode == 'V' then
        -- 行選択モードの場合は、各行全体をカウントする
        start_pos = 1
        end_pos = vim.fn.strlen(vim.fn.getline(end_line)) + 1
    else
        start_pos = vim.fn.col("v")
        end_pos = vim.fn.col(".")
    end

    local chars = 0
    for i = start_line, end_line do
        local line = vim.fn.getline(i)
        local line_len = vim.fn.strlen(line)
        local s_pos = (i == start_line) and start_pos or 1
        local e_pos = (i == end_line) and end_pos or line_len + 1
        chars = chars + vim.fn.strchars(line:sub(s_pos, e_pos - 1))
    end

    local lines = math.abs(end_line - start_line) + 1
    return tostring(lines) .. " 行, " .. tostring(chars) .. " 文字"
end

local opts = {
  options = {
    globalstatus = true,
    --theme = 'OceanicNext'
    theme = 'edge',
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch',
      { 'diff', symbols = { added = ' ', modified = ' ', removed = ' ' }, source = diff_source },
      {'diagnostics', sources = { 'nvim_lsp', 'nvim_diagnostic','nvim_workspace_diagnostic' }, symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' }}
    },
    lualine_c = {{'filename', newfile_status = true, symbols = { modified = '_󰷥', readonly = ' 󱗒', newfile = '󰎔' } }},
    lualine_x = {selectionCount, 'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  tabline = {
    lualine_a = {{'tabs',
      mode = 1,
      section_separators = {left = '', right = ''},
      symbols = {modified = '_󰷥'},
      tabs_color = {
        active = { fg = '#2b2d3a', bg = '#d38aea' },
        inactive = { fg = '#2b2d3a', bg = '#758094' },
      }
    }},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  extensions = { 'lazy', 'mason', 'nvim-tree', 'quickfix', 'toggleterm', 'trouble'}
}

require('lualine').setup(opts)
vim.opt.showtabline = 1

