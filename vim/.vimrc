" vim: nowrap fdm=marker
scriptencoding utf-8

execute pathogen#infect()

" {{{ options
set nocompatible   " don't use vi-compatible mode (even when launched with'vi')

syntax enable      " enable syntax processing

set nobackup       " don't create the FILE.ext~ backup file
set autowrite      " automatically save before :next, :make, etc.

set modeline       " enable modeline processing
set modelines=2    " check first/last two lines of file for modeline

set tabstop=4      " number of visual spaces per TAB
set softtabstop=4  " number of spaces in tab when editing
set shiftwidth=4   " number of spaces to use for reindent and autoindent
set expandtab      " expand all tab values to spaces
set autoindent     " automatically indent new lines
set formatoptions=l " don't break long lines in insert mode
set nowrap          " don't wrap lines for display
set nojoinspaces   " one space (instead of two) after '.?!' when joining lines

set ignorecase     " case-insensitive search
set smartcase      " unless containing uppercase letters
set incsearch      " show 'best match so far' when typing search strings
set hlsearch       " highlight search matches

set ttyscroll=0    " turn off scrolling (this is faster)
set ttyfast        " our tty is fast, so send more chars to screen when redrawing

set encoding=utf-8 " set default encoding to UTF-8
set showbreak=+    " show a '+' if a line is longer than screen
set laststatus=2   " always show status line in last window

set number         " show line numbers
set showcmd        " show last command entered at bottom right
set cursorline     " highlight current line
set wildmenu       " enable visual autocomplete for command menu
set lazyredraw     " only redraw when necessary
set showmatch      " highlight matching [{()}]

set foldlevelstart=20 " start with folds open (level 20)

"set termguicolors
set background=dark
colorscheme candy

" h and l keystrokes should wrap over lines, and ~ (convert case) should
" wrap over lines, and the cursor keys should wrap when in insert mode.
set whichwrap=h,l,~,[,]

set backspace=eol,start,indent  " backspace over all

" characters to show for expanded TABs, trailing whitespace, and end-of-lines:
set listchars=tab:>-,trail:·,eol:$

" path/file expansion in colon-mode
set wildmode=list:longest
set wildchar=<TAB>

" remember on exit:
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo
" }}}

" {{{ mappings
let mapleader=","  " use comma as leader key instead of backslash

" use ', ' to clear highlighted search terms
nnoremap <leader><space> :nohlsearch<CR>

" insert and delete should scroll a couple of lines up or down, respectively,
" without shifting the cursor. They normally just duplicate i and x.
noremap <Ins> 2<C-Y>
noremap <Del> 2<C-E>

" use ',f' to toggle fold open/closed (recursively)
nnoremap <leader>f zA

" have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

" have the usual indentation keystrokes still work in visual mode:
vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>

" have <Tab> (and <Shift>+<Tab> where it works) change the level of
" indentation:
inoremap <Tab> <C-T>
inoremap <S-Tab> <C-D>
" [<Ctrl>+V <Tab> still inserts an actual tab character.]

" F2: Toggle hlsearch (highlight search matches)
nmap <F2> :set hls!<CR>
" F3: Toggle list (display unprintable characters)
noremap <F3> :set list!<CR>
" }}}

" {{{ filetypes
filetype on        " enable filetype detection
filetype plugin on " enable filetype plugins
filetype indent on " enable filetype-specific indent files

augroup configgroup
  autocmd!
  autocmd BufNewFile,BufRead *.txt setl filetype=human
  autocmd FileType human setl formatoptions-=t textwidth=0
  autocmd Filetype gitcommit setl spell textwidth=72
  autocmd FileType c,cpp,java setl formatoptions+=ro
  autocmd FileType c setl omnifunc=ccomplete#Complete
  autocmd FileType javascript setl shiftwidth=4 tabstop=4
  autocmd FileType html,xhtml,css,xml,xslt setl shiftwidth=2 softtabstop=2
  autocmd FileType vim,lua,nginx setl shiftwidth=2 softtabstop=2
  autocmd FileType css setl omnifunc=csscomplete#CompleteCSS
  autocmd FileType xhtml,html setl omnifunc=htmlcomplete#CompleteTags
  autocmd FileType xml setl omnifunc=xmlcomplete#CompleteTags
  autocmd FileType make setl noexpandtab shiftwidth=8 softtabstop=0
  autocmd FileType asm setl noexpandtab shiftwidth=8 softtabstop=0 syntax=nasm
augroup END
" }}}

" {{{ functions
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END
" }}}
