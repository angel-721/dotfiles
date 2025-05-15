vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.updatetime = 300
vim.o.termguicolors = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.opt.spell = true
vim.opt.spelllang = 'en_us'


-- key mappings -- 

vim.keymap.set('n', 'vw', 'viw', { noremap = true })

require("config.lazy")

local api = require "nvim-tree.api"
vim.keymap.set('n', 'tr', api.tree.open, {})
vim.keymap.set('n', 'ty', api.tree.close, {})

vim.diagnostic.config({
  virtual_text = true, -- Shows diagnostics inline with code
  signs = true, -- Displays signs (e.g., error markers) in the gutter
  underline = true, -- Underlines diagnostics in the code
  update_in_insert = false, -- Prevents updating diagnostics while in insert mode
  severity_sort = true, -- Sorts diagnostics by severity for better visibility
})

-- -- LSPs
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('ts_ls')
vim.lsp.enable('cssls')
vim.lsp.enable('htmx')
vim.lsp.enable('html')
vim.lsp.enable('basedpyright')
vim.lsp.enable('svelte')
vim.lsp.enable('gopls')
vim.lsp.enable('tailwindcss')

-- Load after loading plugin
vim.cmd.colorscheme "catppuccin-mocha"
