local c = {
  ground4 = '#7f7f8c',
  camellia = '#cd5c5c',
  leaf = '#9acd32',
  cork = '#bdb76b',
  hyacinth = '#75a0ff',
  lemon = '#eeee00',
  amber = '#cd853f',
  ground3 = '#666666',
  ground5 = '#8a7f7f',
  carmine = '#d70035',
  mint = '#89fb98',
  sand = '#f0e68c',
  oasis = '#6dceeb',
  blond = '#ffde9b',
  lotus = '#ffa0a0',
  ground6 = '#c2bfa5',
  bone = '#ffffff',
  ground1 = '#333333',
  ground2 = '#4d4d4d',
  night = '#000000',
  none = 'NONE'
}

local syntax = {
  Normal = { fg = c.bone, bg = c.ground1 },
  StatusLine = { fg = c.ground1, bg = c.ground6 },
  StatusLineNC = { fg = c.ground4, bg = c.ground6 },
  StatusLineTerm = { fg = c.ground1, bg = c.ground6 },
  StatusLineTermNC = { fg = c.bone, bg = c.ground6 },
  VertSplit = { fg = c.ground4, bg = c.ground6 },
  Pmenu = { fg = c.bone, bg = c.ground3 },
  PmenuSel = { fg = c.ground1, bg = c.sand },
  PmenuSbar = { fg = c.none, bg = c.ground1 },
  PmenuThumb = { fg = c.none, bg = c.ground6 },
  TabLine = { fg = c.ground1, bg = c.ground6 },
  TabLineFill = { fg = c.none, bg = c.ground6 },
  TabLineSel = { fg = c.ground1, bg = c.sand },
  ToolbarLine = { fg = c.none, bg = c.ground3 },
  ToolbarButton = { fg = c.ground1, bg = c.blond },
  NonText = { fg = c.oasis, bg = c.ground2 },
  SpecialKey = { fg = c.leaf, bg = c.none },
  Folded = { fg = c.lemon, bg = c.ground2 },
  Visual = { fg = c.sand, bg = c.leaf },
  VisualNOS = { fg = c.sand, bg = c.oasis },
  LineNr = { fg = c.lemon, bg = c.none },
  FoldColumn = { fg = c.lemon, bg = c.ground2 },
  CursorLine = { fg = c.none, bg = c.ground3 },
  CursorColumn = { fg = c.none, bg = c.ground3 },
  CursorLineNr = { fg = c.lemon, bg = c.none },
  QuickFixLine = { fg = c.ground1, bg = c.sand },
  SignColumn = { fg = c.none, bg = c.none },
  Underlined = { fg = c.hyacinth, bg = c.none },
  Error = { fg = c.carmine, bg = c.bone },
  ErrorMsg = { fg = c.carmine, bg = c.bone },
  ModeMsg = { fg = c.blond, bg = c.none },
  WarningMsg = { fg = c.camellia, bg = c.none },
  MoreMsg = { fg = c.leaf, bg = c.none },
  Question = { fg = c.mint, bg = c.none },
  Todo = { fg = c.carmine, bg = c.lemon },
  MatchParen = { fg = c.ground4, bg = c.cork },
  Search = { fg = c.sand, bg = c.ground4 },
  IncSearch = { fg = c.sand, bg = c.amber },
  WildMenu = { fg = c.ground1, bg = c.lemon },
  ColorColumn = { fg = c.bone, bg = c.camellia },
  Cursor = { fg = c.ground1, bg = c.sand },
  lCursor = { fg = c.ground1, bg = c.carmine },
  debugPC = { fg = c.ground3, bg = c.none },
  debugBreakpoint = { fg = c.lotus, bg = c.none },
  SpellBad = { fg = c.camellia, bg = c.none },
  SpellCap = { fg = c.hyacinth, bg = c.none },
  SpellLocal = { fg = c.blond, bg = c.none },
  SpellRare = { fg = c.leaf, bg = c.none },
  Comment = { fg = c.oasis, bg = c.none },
  Identifier = { fg = c.mint, bg = c.none },
  Statement = { fg = c.sand, bg = c.none },
  Constant = { fg = c.lotus, bg = c.none },
  PreProc = { fg = c.camellia, bg = c.none },
  Type = { fg = c.cork, bg = c.none },
  Special = { fg = c.blond, bg = c.none },
  Directory = { fg = c.oasis, bg = c.none },
  Conceal = { fg = c.ground3, bg = c.none },
  Ignore = { fg = c.none, bg = c.none },
  Title = { fg = c.camellia, bg = c.none },
  DiffAdd = { fg = c.bone, bg = '#5f875f' },
  DiffChange = { fg = c.bone, bg = '#5f87af' },
  DiffText = { fg = c.night, bg = '#c6c6c6' },
  DiffDelete = { fg = c.bone, bg = '#af5faf' },

  ["@tag.attribute"] = { fg = c.camellia },
  ["@punctuation.bracket"] = { fg = c.lemon },
  Keyword = { fg = c.hyacinth },
  ["@property"] = { fg = c.blond },
}



local set_hl = function(tbl)
  for group, conf in pairs(tbl) do
    vim.api.nvim_set_hl(0, group, conf)
  end
end

function c.colorscheme()
  vim.api.nvim_command("hi clear")

  vim.o.background = "dark"
  vim.o.termguicolors = true
  vim.g.colors_name = "desertnvim"
  set_hl(syntax)
end

c.colorscheme()

return c
