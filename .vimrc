set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
" non github repos
Bundle 'git://git.wincent.com/command-t.git'
" L9 required for FuzzyFinder
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'guns/xterm-color-table.vim'

" Color Schemes
Bundle 'vim-scripts/molokai'

" Syntax Repos
Bundle 'kchmck/vim-coffee-script'
Bundle 'chrisbra/csv.vim'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-haml'
Bundle 'wlangstroth/vim-haskell'
Bundle 'pangloss/vim-javascript'
Bundle 'groenewege/vim-less'
Bundle 'tpope/vim-markdown'
Bundle 'sunaku/vim-ruby-minitest'
Bundle 'mmalecki/vim-node.js'
Bundle 'ajf/puppet-vim'
Bundle 'tpope/vim-rails.git'
Bundle 'skwp/vim-rspec'
Bundle 'vim-ruby/vim-ruby'
Bundle 'rosstimson/scala-vim-support'
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'slim-template/vim-slim'
Bundle 'timcharper/textile.vim'

filetype plugin indent on

" Set some file types
" Set the Ruby filetype for a number of common Ruby files without .rb
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,Procfile,Guardfile,config.ru,*.rake} set ft=ruby


colorscheme molokai
:set t_Co=256

set shell=/bin/sh
set ttymouse=xterm2
set mouse=a

syntax on
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
au BufNewFile,BufRead *.jsm setf javascript


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

map <leader>f :CommandTFlush<cr>\|:CommandT<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
map <leader>c :w\|:!script/features<cr>
map <leader>w :w\|:!script/features --profile wip<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\|_test.py\)$') != -1
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
        elseif filereadable("script/test")
            exec ":!script/test " . a:filename
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

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=green

" default the statusline to green when entering Vim
hi statusline guibg=green

" strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Prevent memory leak from making Vim really slow from matches
autocmd BufWinLeave * call clearmatches()

" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100
