vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.updatetime = 300
vim.o.termguicolors = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true


-- key mappings -- 

vim.keymap.set('n', 'vw', 'viw', { noremap = true })

require("config.lazy")

local api = require "nvim-tree.api"
vim.keymap.set('n', 'tr', api.tree.open, {})
vim.keymap.set('n', 'ty', api.tree.close, {})
local function setup_lsp_diags()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      virtual_text = false,
      signs = true,
      update_in_insert = false,
      underline = true,
    }
  )
end


-- Load after loading plugin
vim.cmd.colorscheme "catppuccin-mocha"
