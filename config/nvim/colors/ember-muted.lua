-- ember-muted.lua
-- Svartsandur Ember Muted — same palette as the VS Code theme / nanorc.
vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') == 1 then
  vim.cmd('syntax reset')
end
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.g.colors_name = 'ember-muted'

local c = {
  bg       = '#0e1515',
  bg_alt   = '#0c1110',
  bg_float = '#151e1d',
  bg_sel   = '#203231',
  bg_line  = '#172120',
  border   = '#232f2e',
  fg       = '#e0d9d1',
  fg_dim   = '#9c8f81',
  fg_faint = '#4b5857',
  comment  = '#60766b',
  string   = '#d0ba95',
  keyword  = '#67a29e',
  func     = '#c4826e',
  type     = '#79b1c3',
  variable = '#d8d1ca',
  constant = '#c2735b',
  accent   = '#c27861',
  red      = '#d45c54',
  green    = '#68b18c',
  yellow   = '#e0be7b',
  orange   = '#db7e57',
  purple   = '#b49ac1',
}

local hl = vim.api.nvim_set_hl

hl(0, 'Normal',       { fg = c.fg, bg = c.bg })
hl(0, 'NormalFloat',  { fg = c.fg, bg = c.bg_float })
hl(0, 'FloatBorder',  { fg = c.border, bg = c.bg_float })
hl(0, 'Comment',      { fg = c.comment, italic = true })
hl(0, 'SpecialComment', { fg = c.comment, italic = true })
hl(0, 'String',       { fg = c.string })
hl(0, 'Character',    { fg = c.string })
hl(0, 'Number',       { fg = c.constant })
hl(0, 'Float',        { fg = c.constant })
hl(0, 'Boolean',      { fg = c.keyword })
hl(0, 'Identifier',   { fg = c.variable })
hl(0, 'Function',     { fg = c.func })
hl(0, 'Statement',    { fg = c.keyword })
hl(0, 'Conditional',  { fg = c.keyword })
hl(0, 'Repeat',       { fg = c.keyword })
hl(0, 'Label',        { fg = c.keyword })
hl(0, 'Keyword',      { fg = c.keyword })
hl(0, 'Operator',     { fg = c.fg_dim })
hl(0, 'Exception',    { fg = c.red })
hl(0, 'PreProc',      { fg = c.purple })
hl(0, 'Include',      { fg = c.purple })
hl(0, 'Define',       { fg = c.purple })
hl(0, 'Macro',        { fg = c.purple })
hl(0, 'Type',         { fg = c.type })
hl(0, 'StorageClass', { fg = c.type })
hl(0, 'Structure',    { fg = c.type })
hl(0, 'Typedef',      { fg = c.type })
hl(0, 'Special',      { fg = c.orange })
hl(0, 'SpecialChar',  { fg = c.orange })
hl(0, 'Tag',          { fg = c.keyword })
hl(0, 'Delimiter',    { fg = c.fg_dim })
hl(0, 'Underlined',   { fg = c.accent, underline = true })
hl(0, 'Error',        { fg = c.red, bold = true })
hl(0, 'ErrorMsg',     { fg = c.red, bold = true })
hl(0, 'WarningMsg',   { fg = c.yellow })
hl(0, 'Todo',         { fg = c.bg, bg = c.yellow, bold = true })

hl(0, 'LineNr',       { fg = c.fg_faint })
hl(0, 'CursorLineNr', { fg = c.fg_dim })
hl(0, 'CursorLine',   { bg = c.bg_line })
hl(0, 'CursorColumn', { bg = c.bg_line })
hl(0, 'ColorColumn',  { bg = c.bg_line })
hl(0, 'Visual',       { bg = c.bg_sel })
hl(0, 'VisualNOS',    { bg = c.bg_sel })
hl(0, 'Search',       { fg = c.bg, bg = c.yellow })
hl(0, 'IncSearch',    { fg = c.bg, bg = c.accent })
hl(0, 'CurSearch',    { fg = c.bg, bg = c.accent })

hl(0, 'Pmenu',        { fg = c.fg, bg = c.bg_float })
hl(0, 'PmenuSel',     { fg = c.bg, bg = c.accent })
hl(0, 'PmenuSbar',    { bg = c.bg_float })
hl(0, 'PmenuThumb',   { bg = c.fg_faint })

hl(0, 'StatusLine',   { fg = c.fg_dim, bg = c.bg_alt })
hl(0, 'StatusLineNC', { fg = c.fg_faint, bg = c.bg_alt })
hl(0, 'TabLine',      { fg = c.fg_dim, bg = c.bg_alt })
hl(0, 'TabLineSel',   { fg = c.fg, bg = c.bg })
hl(0, 'TabLineFill',  { bg = c.bg_alt })
hl(0, 'WinSeparator', { fg = c.border })
hl(0, 'VertSplit',    { fg = c.border })
hl(0, 'SignColumn',   { bg = c.bg })
hl(0, 'FoldColumn',   { fg = c.fg_faint, bg = c.bg })
hl(0, 'Folded',       { fg = c.fg_dim, bg = c.bg_line })

hl(0, 'DiffAdd',      { fg = c.green, bg = c.bg_line })
hl(0, 'DiffChange',   { fg = c.yellow, bg = c.bg_line })
hl(0, 'DiffDelete',   { fg = c.red, bg = c.bg_line })
hl(0, 'DiffText',     { fg = c.accent, bg = c.bg_line })

hl(0, 'MatchParen',   { fg = c.accent, bold = true, underline = true })
hl(0, 'NonText',      { fg = c.fg_faint })
hl(0, 'EndOfBuffer',  { fg = c.bg })
hl(0, 'Whitespace',   { fg = c.fg_faint })
hl(0, 'Title',        { fg = c.keyword, bold = true })
hl(0, 'Directory',    { fg = c.keyword })
hl(0, 'MoreMsg',      { fg = c.green })
hl(0, 'Question',     { fg = c.green })

-- Treesitter / LSP, linked to the base groups above
hl(0, '@variable',        { link = 'Identifier' })
hl(0, '@function',        { link = 'Function' })
hl(0, '@keyword',         { link = 'Keyword' })
hl(0, '@string',          { link = 'String' })
hl(0, '@comment',         { link = 'Comment' })
hl(0, '@type',            { link = 'Type' })
hl(0, '@constant',        { link = 'Number' })
hl(0, '@constant.builtin',{ link = 'Boolean' })
hl(0, '@punctuation',     { link = 'Delimiter' })
hl(0, 'DiagnosticError',  { fg = c.red })
hl(0, 'DiagnosticWarn',   { fg = c.yellow })
hl(0, 'DiagnosticInfo',   { fg = c.type })
hl(0, 'DiagnosticHint',   { fg = c.comment })
