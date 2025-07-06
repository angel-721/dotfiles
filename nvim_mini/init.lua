local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  })
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up mini.deps
require('mini.deps').setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- ========= Disable builtin plugins =========
now(function()
  vim.g.loaded_gzip = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_matchit = 1      
  vim.g.loaded_matchparen = 1     
	vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
  vim.g.loaded_tutor_mode_plugin = 1
  vim.g.loaded_remote_plugins = 1
  vim.g.loaded_spellfile_plugin = 1
end)

-- ========= Basic Settings =========
now(function()
  vim.o.number = true
  vim.o.signcolumn = 'yes'
  vim.o.tabstop = 2
  vim.o.shiftwidth = 2
  vim.o.updatetime = 300
  vim.o.completeopt = 'menuone,noselect'
  vim.opt.termguicolors = true
  vim.opt.sessionoptions:remove('blank')

  -- SuperTab keymaps
  local imap_expr = function(lhs, rhs)
    vim.keymap.set('i', lhs, rhs, { expr = true, silent = true })
  end
  imap_expr('<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
  imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

  -- Accept item on <CR>
  _G.cr_action = function()
    return vim.fn.complete_info().selected ~= -1 and '\25' or '\r'
  end
  vim.keymap.set('i', '<CR>', 'v:lua.cr_action()', { expr = true })
  
  vim.keymap.set('n', 'ff', function()
    vim.cmd('Pick files')
  end, { desc = 'Pick Files' })

  vim.keymap.set('n', 'fg', function()
    vim.cmd('Pick grep_live')
  end, { desc = 'Pick Live Grep' })
  
  require('mini.starter').setup()
end)

-- ========= Defer LSP and completion until needed =========
later(function()
  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc',
      auto_setup = false,  
    },
  })

  -- Set up LSP completion on every LSP attach
  local on_attach = function(args)
    vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  end
  vim.api.nvim_create_autocmd('LspAttach', { callback = on_attach })

  -- Enable LSP servers only when needed
  local lsp_servers = {
    'rust_analyzer',
    'ts_ls',
    'cssls',
    'html',
    'basedpyright',
    'gopls',
    'tailwindcss',
  }
  
  -- Only enable LSP for specific filetypes
  local filetype_to_lsp = {
    rust = { 'rust_analyzer' },
    typescript = { 'ts_ls', 'tailwindcss' },
    typescriptreact = { 'ts_ls', 'tailwindcss' },
    javascript = { 'ts_ls', 'tailwindcss' },
    javascriptreact = { 'ts_ls', 'tailwindcss' },
    css = { 'cssls', 'tailwindcss' },
    html = { 'html', 'tailwindcss' },
    python = { 'basedpyright' },
    go = { 'gopls' },
  }
  
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local servers = filetype_to_lsp[args.match]
      if servers then
        vim.lsp.enable(servers)
      end
    end,
  })
  
  vim.lsp.set_log_level("off")
end)

-- ========= Diagnostics config =========
later(function()
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })
end)

-- ========= TreeSitter with vim-matchup =========
later(function()
  local treesitter_filetypes = {
    'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
    'html', 'css', 'json', 'lua', 'python', 'rust', 'go',
    'markdown', 'yaml', 'toml', 'vim', 'bash', 'sh'
  }
  
	-- Only load treesitter when I need it
  local treesitter_loaded = false
  
  local function setup_treesitter()
    if treesitter_loaded then return end
    
    add({
      source = 'nvim-treesitter/nvim-treesitter',
      checkout = 'master',
      monitor = 'main',
      hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
    })

    add({
      source = 'andymass/vim-matchup',
      monitor = 'master',
    })
    
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
    
    require('nvim-treesitter.configs').setup({
      ensure_installed = {  },
      highlight = { enable = true },
      matchup = {
        enable = true,
        disable = { },
      },
    })
    
    treesitter_loaded = true
  end
  
  vim.api.nvim_create_autocmd('FileType', {
    pattern = treesitter_filetypes,
    callback = setup_treesitter,
  })
end)
-- ========= Autotag only for specific filetypes =========
later(function()
  add({
    source = 'windwp/nvim-ts-autotag',
    monitor = 'main',
  })
  
  -- Only set up autotag when we encounter relevant filetypes
  local autotag_filetypes = {
    'html', 'xml', 'javascript', 'typescript', 
    'javascriptreact', 'typescriptreact', 'vue', 'svelte'
  }
  
  local autotag_setup = false
  vim.api.nvim_create_autocmd('FileType', {
    pattern = autotag_filetypes,
    callback = function()
      if not autotag_setup then
        require('nvim-ts-autotag').setup({
          opts = {
            enable_close = true,
            enable_rename = true,
            enable_close_on_slash = false
          },
          per_filetype = {
            ["html"] = { enable_close = true }
          }
        })
        autotag_setup = true
      end
    end,
  })
end)

-- ========= Conform with specific formatters =========
later(function()
  add({
    source = 'stevearc/conform.nvim',
    monitor = 'master',
  })
  
  require("conform").setup({
    formatters_by_ft = {
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      css = { "prettierd" },
      html = { "prettierd" },
      json = { "prettierd" },
    },
    format_on_save = {
      timeout_ms = 500,
    },
  })
end)

-- ========= Theme =========
later(function()
  add({ source = "catppuccin/nvim", name = "catppuccin" })
  vim.cmd.colorscheme "catppuccin"
end)

-- ========= Mini modules =========
later(function()
  require('mini.pairs').setup()
  require('mini.pick').setup()
  require('mini.diff').setup()
  require('mini.surround').setup()
  require('mini.align').setup()
end)
