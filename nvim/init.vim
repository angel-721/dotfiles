:set termguicolors
:set number
:colorscheme strawberry-light
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
" :autocmd BufWritePost, *.tex !pdftex <afile>
:autocmd BufWritePost, *.html,*.js,*.css Prettier



"PLUGINS "
"
"
call plug#begin()
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/vim-grammarous'
Plug 'chrisbra/csv.vim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'tpope/vim-cucumber'
Plug 'alaviss/nim.nvim'
Plug 'ericvw/vim-nim'
Plug 'nvimdev/guard-collection'
Plug 'nvimdev/guard.nvim'
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next','do': 'bash install.sh' }
Plug 'dense-analysis/ale'
Plug 'cuducos/yaml.nvim'
Plug 'elzr/vim-json'
Plug 'lervag/vimtex'
" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }
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
" VIMTEXT "
"
" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note that most plugin managers will do this automatically.
filetype plugin indent on

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
let g:vimtex_view_method = 'zathura'

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
let g:vimtex_compiler_method = 'latexrun'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let maplocalleader = ",""
"
"
"

"
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

--
-- TREESITTER
--
require('nvim-treesitter.configs').setup {
	ensure_installed = {"nim", "cpp", "python", "javascript"},
  hightlight = { enable = true },
  indent = { enable = true }
}


--
-- GUARD
--
local ft = require('guard.filetype')

ft('cpp'):fmt('clang-format')
       :lint('clang-tidy')

--- ft('typescript,javascript,typescriptreact, html, css, markdown'):fmt('prettier')

-- Call setup() LAST!
require('guard').setup({
    -- the only options for the setup function
    fmt_on_save = true,
    -- Use lsp if no formatter was defined for this filetype
    lsp_as_default_formatter = false,
})
EOF
