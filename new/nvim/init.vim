:set termguicolors
:set number
:syntax on
:syntax enable
:filetype plugin indent on
:set lazyredraw
:set ttyfast
:syntax sync fromstart
:set autoindent
:set nowrap
:set smartindent
:set ruler
:set lbr
:set ts=2
:set sw=2
:set tw=80
:set colorcolumn=80
:set fo+=t
:set nocursorcolumn
:set nocursorline
:set nojoinspaces
:set hlsearch
:set incsearch
:set showmatch
:set textwidth=80
:set shell=bash
:set shellcmdflag=-lc
:autocmd BufNewFile,BufRead *.txt,*.tex,*.md setlocal spell spelllang=en_us
:autocmd BufWritePre * :%s/\s\+$//e
:autocmd VimEnter * TSEnable highlight



"
"
" PLUGINS "
"
"
call plug#begin()
Plug 'jiangmiao/auto-pairs'
Plug 'github/copilot.vim'
Plug 'ziglang/zig.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'leafOfTree/vim-svelte-plugin'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'cdelledonne/vim-cmake'
Plug 'easymotion/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/vim-grammarous'
Plug 'chrisbra/csv.vim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'echasnovski/mini.nvim'
Plug 'goolord/alpha-nvim'
Plug 'tpope/vim-cucumber'
Plug 'alaviss/nim.nvim'
Plug 'ericvw/vim-nim'
Plug 'nvimdev/guard-collection'
Plug 'nvimdev/guard.nvim'
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next','do': 'bash install.sh' }
Plug 'dense-analysis/ale'
Plug 'tikhomirov/vim-glsl'
Plug 'cuducos/yaml.nvim'
Plug 'elzr/vim-json'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nyoom-engineering/oxocarbon.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'lervag/vimtex'
Plug 'folke/tokyonight.nvim'
call plug#end()



"
"
" NIMLINT "
"
"
let g:ale_sign_error                  = '✘'
let g:ale_sign_warning                = '⚠'
highlight ALEErrorSign ctermbg        =NONE ctermfg=red
highlight ALEWarningSign ctermbg      =NONE ctermfg=yellow
let g:ale_linters_explicit            = 1
let g:ale_lint_on_text_changed        = 'never'
let g:ale_lint_on_enter               = 0
let g:ale_lint_on_save                = 1
let g:ale_fix_on_save                 = 1

let g:ale_linters = {
\   'nim':      ['nimlsp', 'nimcheck'],
\}

let g:ale_fixers = {
\   'nim':      ['nimpretty'],
\   '*':        ['remove_trailing_lines', 'trim_whitespace'],
\}



"
"
" COC "
"
" May need for vim (not neovim) since coc.nvim calculate byte offset by count
" utf-8 byte sequence.
set encoding=utf-8
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Detect .nyat files and set the syntax
augroup filetype_nyat
  autocmd!
  autocmd BufRead,BufNewFile *.nyat setlocal filetype=nyat
augroup END
autocmd FileType nyat setlocal commentstring=#\ %s


function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
"Snippets"
"
"
"
imap <C-l> <Plug>(coc-snippets-expand)
imap <C-j> <Plug>(coc-snippets-expand-jump)



"
" FILE TYPE
"
"
autocmd FileType python setlocal sw=4 ts=4



"
" LUA
"
"
lua <<EOF

   vim.g.clipboard = {
        name = "win64yank-wsl",
        copy = {
            ["+"] = "win32yank.exe -i --crlf",
            ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "win32yank.exe -o --lf",
            ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = true,
    }

--
-- TREESITTER
--
require('nvim-treesitter.configs').setup {
	ensure_installed = {"nim", "cpp", "python", "javascript"},
	auto_install = false,
  hightlight = { enable = true },
  indent = { enable = true }
}


-- Telescope lua config
local builtin = require('telescope.builtin')
vim.keymap.set('n', 'ff', builtin.find_files, {})
vim.keymap.set('n', 'fg', builtin.live_grep, {})
vim.keymap.set('n', 'vw', 'viw', { noremap = true })


-- COLORSCHEME
vim.opt.background = "light" -- set this to dark or light
vim.cmd.colorscheme "tokyonight-night"

--
-- GUARD
--
local ft = require('guard.filetype')

ft('cpp'):fmt('clang-format')
       :lint('clang-tidy')

ft('rust'):fmt('rustfmt')

ft('typescript,javascript,typescriptreact,html,css,markdown,svelte,astro'):fmt('prettierd')

-- Call setup() LAST!
vim.g.guard_config = {
    -- the only options for the setup function
    fmt_on_save = true,
    -- Use lsp if no formatter was defined for this filetype
    lsp_as_default_formatter = true,
}

require'alpha'.setup(require'alpha.themes.startify'.config)
EOF
