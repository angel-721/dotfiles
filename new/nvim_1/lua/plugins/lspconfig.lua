-- return{
--   {
--     "neovim/nvim-lspconfig",
-- 	dependencies = { 'saghen/blink.cmp' },
--     event = { "BufReadPre", "BufNewFile" },
-- 	config = function()
-- 			require("lspconfig").basedpyright.setup{
-- 				      capabilities = capabilities,
-- 			}
-- 			require('lspconfig').clangd.setup{}
-- 	end,
--   }
-- }

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { 'saghen/blink.cmp' },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")

      -- Configure diagnostics
      vim.diagnostic.config({
        virtual_text = true, -- Show inline error messages
        signs = true,        -- Display error signs in the gutter
        underline = true,    -- Underline errors in the code
        update_in_insert = false, -- Avoid updates while typing
      })

      -- Customize how diagnostics appear
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
          virtual_text = {
            spacing = 4,
            prefix = "●", -- Customize the symbol
          },
          signs = true,
          underline = true,
          update_in_insert = false,
        }
      )

      -- Setup LSP servers
      lspconfig.basedpyright.setup{
        capabilities = capabilities,
      }
      lspconfig.clangd.setup{
        capabilities = capabilities,
      }
    end,
  }
}

