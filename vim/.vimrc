set modeline
set modelines=5

set expandtab
set tabstop=4
set shiftwidth=4

syntax enable

" don't use vi-compatible mode even if launched with 'vi'
set nocompatible

" don't use any backup temp file
set nobackup

" never insert a newline automatically
set formatoptions=l
set nowrap

" h and l keystrokes should wrap over lines, and ~ (convert case) should
" wrap over lines, and the cursor keys should wrap when in insert mode.
set whichwrap=h,l,~,[,]

" allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

" Insert and Delete should scroll a couple of lines up or down, respectively,
" without shifting the cursor. They normally just duplicate i and x.
noremap <Ins> 2<C-Y>
noremap <Del> 2<C-E>

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" show the `best match so far' as search strings are typed:
set incsearch

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

autocmd Filetype gitcommit setlocal spell textwidth=72
set tabstop=4      " Use n spaces for << and >> (and other things)
set shiftwidth=4   " Number of spaces to use for an (auto)indent step
set softtabstop=4  " <Tab> inserts n spaces (but replaces 8 with tabs)
set expandtab      " Expand all tab values to spaces
set autoindent     " Automatically indent new lines
set smarttab

set ttyscroll=0    " Turn off scrolling (this is faster)
set ttyfast        " We have a fast terminal connection
set hlsearch       " Highlight search matches

set encoding=utf-8 " Set default encoding to UTF-9
set showbreak=+    " Show a '+' if a line is longer than screen
set laststatus=2   " When to show a statusline
set autowrite      " Automatically save before :next, :make, etc.

" Tell vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines.
set listchars=tab:>-,trail:·,eol:$

" Path/file expansion in colon-mode
set wildmode=list:longest
set wildchar=<TAB>

" enable filetype detection:
filetype on
filetype plugin on
filetype indent on " file type based indentation

augroup filetype
  autocmd BufNewFile,BufRead *.txt set filetype=human
augroup END

autocmd FileType human set formatoptions-=t textwidth=0 " disable wrapping in txt

" for C-like  programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c,cpp,java set formatoptions+=ro
autocmd FileType c set omnifunc=ccomplete#Complete

" fixed indentation should be OK for XML and CSS. People have fast internet
" anyway. Indentation set to 2.
autocmd FileType html,xhtml,css,xml,xslt set shiftwidth=2 softtabstop=2

" two space indentation for some files
autocmd FileType vim,lua,nginx set shiftwidth=2 softtabstop=2

" for CSS, also have things in braces indented:
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" add completion for xHTML
autocmd FileType xhtml,html set omnifunc=htmlcomplete#CompleteTags

" add completion for XML
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" ensure normal tabs in assembly files
" and set to NASM syntax highlighting
autocmd FileType asm set noexpandtab shiftwidth=8 softtabstop=0 syntax=nasm

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

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

" F2: Toggle hlsearch (highlight search matches)
nmap <F2> :set hls!<CR>

" F3: Toggle list (display unprintable characters)
noremap <F3> :set list!<CR>
