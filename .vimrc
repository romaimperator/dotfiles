set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required!
Plugin 'gmarik/Vundle.vim'

" My Bundles here:
"
" original repos on github
Plugin 'tpope/vim-fugitive'

Plugin 'git://git.wincent.com/command-t.git'

" L9 required for FuzzyFinder
Plugin 'L9'
Plugin 'FuzzyFinder'
Plugin 'guns/xterm-color-table.vim'

" Color Schemes
Plugin 'vim-scripts/molokai'
Plugin 'altercation/vim-colors-solarized'

" Dispatch
Plugin 'tpope/vim-dispatch.git'

" Syntax Repos
Plugin 'tpope/vim-commentary.git'
Plugin 'tpope/vim-cucumber'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-rails.git'
Plugin 'tpope/vim-rbenv.git'
Plugin 'tpope/vim-markdown'
Plugin 'kchmck/vim-coffee-script'
Plugin 'chrisbra/csv.vim'
Plugin 'wlangstroth/vim-haskell'
Plugin 'pangloss/vim-javascript'
Plugin 'groenewege/vim-less'
Plugin 'sunaku/vim-ruby-minitest'
Plugin 'mmalecki/vim-node.js'
Plugin 'ajf/puppet-vim'
Plugin 'skwp/vim-rspec'
Plugin 'vim-ruby/vim-ruby'
Plugin 'rosstimson/scala-vim-support'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'slim-template/vim-slim'
Plugin 'timcharper/textile.vim'
Plugin 'jgdavey/tslime.vim'

Plugin 'scrooloose/syntastic'

Plugin 'junegunn/vim-easy-align'

call vundle#end()            " required

"call plug#begin('~/.vim/bundle')
"
"Plug 'tpope/vim-fugitive'
"Plug 'git://git.wincent.com/command-t.git'
"Plug 'L9'
"Plug 'FuzzyFinder'
"Plug 'guns/xterm-color-table.vim'
"
"" Color Schemes
"Plug 'vim-scripts/molokai', { 'on': 'molokai' }
"Plug 'altercation/vim-colors-solarized'
"
"" Syntax Repos
"Plug 'tpope/vim-commentary'
"Plug 'tpope/vim-cucumber', { 'for': 'cucumber' }
"Plug 'tpope/vim-git'
"Plug 'tpope/vim-haml', { 'for': 'haml' }
"Plug 'tpope/vim-rails'
"Plug 'tpope/vim-rbenv'
"Plug 'kchmck/vim-coffee-script', { 'for': 'coffeescript' }
"Plug 'chrisbra/csv.vim', { 'for': 'csv' }
"Plug 'wlangstroth/vim-haskell', { 'for': 'haskell' }
"Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
"Plug 'groenewege/vim-less', { 'for': 'less' }
"Plug 'tpope/vim-markdown', { 'for': 'markdown' }
"Plug 'sunaku/vim-ruby-minitest'
"Plug 'mmalecki/vim-node.js', { 'for': 'node' }
"Plug 'ajf/puppet-vim'
"Plug 'skwp/vim-rspec', { 'for': 'rspec' }
"Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
"Plug 'rosstimson/scala-vim-support', { 'for': 'scala' }
"Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
"Plug 'slim-template/vim-slim'
"Plug 'timcharper/textile.vim'
"Plug 'jgdavey/tslime.vim'
"
"Plug 'junegunn/vim-easy-align'
"
"call plug#end()

"filetype plugin indent on " Handled by vim-plug, plug#end()
filetype plugin indent on

" Set some file types
" Set the Ruby filetype for a number of common Ruby files without .rb
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Guardfile,config.ru,*.rake} set ft=ruby

set shell=/bin/zsh

"syntax on " Handled by vim-plug, plug#end()
syntax on
set t_Co=256
set background=light
let g:solarized_termcolors=16
let g:solarized_termtrans=1
colorscheme solarized
"colorscheme molokai

set shell=/bin/sh
set ttymouse=xterm2
set mouse=a
set cc=80

set wrap

map <F1> :bf<CR>
map <F2> :bp<CR>
map <F3> :bn<CR>
map <F4> :bl<CR>
map <F5> :ls<CR>
map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-W>l
map <C-s> :w<CR>
nmap <leader>j :lnext<CR>
nmap <leader>k :lprevious<CR>
au BufNewFile,BufRead *.jsm setf javascript

au BufEnter /private/tmp/crontab.* setl backupcopy=yes

" Default sessionoptions
" set sessionoptions=blank,buffers,curdir,folds,help,options,tabpages,winsize
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" Syntastic Suggested Options
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
"let g:syntastic_ruby_checkers = ['ruby', 'rubocop']
let g:syntastic_aggregate_errors = 1

function AlignBlock() range
    if col(".") > 1
        echo "You can only align in Visual Mode"
        return
    endif
    let l:lines = getline(a:firstline, a:lastline)
    let l:lineNumber = a:firstline
    let l:column = col("'<")
    for l:line in l:lines
        if l:column > 1
            let l:lastSpaceColumn = strridx(l:line[0:l:column-1], " ")
            if l:lastSpaceColumn > -1 && l:lastSpaceColumn < l:column-1
                let l:index = l:lastSpaceColumn
                while l:index < l:column-1
                    let l:line = l:line[0:l:lastSpaceColumn] . ' ' . l:line[l:lastSpaceColumn + 1:len(l:line)]
                    let l:index = l:index + 1
                endwhile
            endif
        endif
        let l:newline = substitute(line, "\\(.\\{" . (l:column - 1) . "\\}\\)\\s*", "\\1", "")
        call setline(l:lineNumber, l:newline)
        let l:lineNumber = l:lineNumber + 1
    endfor
    call cursor(line("."), l:column)
endfunction

"vmap \a :call AlignBlock()<CR>
vmap \a :call Align =<CR>
vmap <silent> <Enter> :EasyAlign<cr>

set ttimeoutlen=50

if &term =~ "xterm" || &term =~ "screen"
    let g:CommandTCancelMap     = ['<ESC>', '<C-c>']
    let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<ESC>OB']
    let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<ESC>OA']
endif

" highlight current line
set cursorline
" allow unsaved background buffers and remember marks/undo for them
set hidden
set winwidth=79
set winminwidth=20
set winwidth=79
set winheight=5
set winminheight=5
set winheight=999
set noequalalways
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
set history=10000
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
set number

set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu
let mapleader=","


" GRB: use fancy buffer closing that doesn't close the split
"cnoremap <expr> bd (getcmdtype() == ':' ? 'Bclose' : 'bd')

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=80
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()
nnoremap <leader><leader> <c-^>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMAND-T CONFIG
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
let g:CommandTFileScanner="git" " Controls the file scanner used
let g:CommandTMaxHeight=30      " Sets the maximum height of the results window

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>t :call RunTestFile()<cr>
nnoremap <leader>T :call RunNearestTest()<cr>
nnoremap <leader>a :call RunTests('')<cr>
nnoremap <leader>c :w\|:!script/features<cr>
nnoremap <leader>w :w\|:!script/features --profile wip<cr>
nnoremap <leader>r :w\|:!script/features @rerun.txt<cr>
"map <leader>c :w\|:call Send_to_Tmux("script/features\n")<cr>
"map <leader>w :w\|:call Send_to_Tmux("script/features --profile wip\n")<cr>
nnoremap <leader>s :A<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\|_test.py\|_test.go\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        echo "show filename: " . a:filename
        if filereadable("tests.sh")
            exec ":!./tests.sh " . a:filename
            "let cmd = 'rspec --color --format progress --require "~/lib/vim_rspec_formatter" --format VimFormatter'
            "call Send_to_Tmux("spring " . cmd . "\n")
            "exec ":!echo " . cmd . " " . a:filename . " > .test-commands"

            " Write an empty string to block until the command completes
            "sleep 100m " milliseconds
            ":!echo > .test-commands
            "redraw!
        elseif filereadable("script/test")
            "call Send_to_Tmux("script/test " . a:filename . "\n")
            exec ":!script/test " . a:filename
            "redraw!
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=magenta
  elseif a:mode == 'r'
    hi statusline guibg=blue
  else
    hi statusline guibg=red
  endif
endfunction

"au InsertEnter * call InsertStatuslineColor(v:insertmode)
"au InsertLeave * hi statusline guibg=green

" default the statusline to green when entering Vim
"hi statusline guibg=green

" strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Prevent memory leak from making Vim really slow from matches
autocmd BufWinLeave * call clearmatches()

" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100
