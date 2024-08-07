set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Keep Plugin commands between vundle#begin/end.
Plugin 'altercation/vim-colors-solarized'
Plugin 'luochen1990/rainbow'
Plugin 'ryanoasis/vim-devicons'
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim'}
"Plugin 'vim-airline/vim-airline'
"Plugin 'vim-airline/vim-airline-themes'
Bundle 'Valloric/YouCompleteMe'
Plugin 'Valloric/ListToggle'
Plugin 'preservim/nerdcommenter'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'scrooloose/nerdtree'
Plugin 'preservim/tagbar'
Plugin 'mileszs/ack.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'fatih/vim-go'
Plugin 'hashivim/vim-terraform'
Plugin 'github/copilot.vim'

call vundle#end()            " required
filetype plugin indent on    " required
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
" === Vundle End ===



let mapleader = " "



" Toggle Background Color (dark/light)
call togglebg#map("<F5>")
"let g:solarized_termcolors=256
set background=dark
colorscheme solarized


" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
    let &t_ti = "\<Esc>]50;CursorShape=0\x7" " Start as block in normal mode
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
    let &t_te = "\<Esc>]50;CursorShape=1\x7" " Back to vertical bar on exit
    set ttimeoutlen=50 " Timeout in ms for Escape (back quickly to normal mode)
endif


" General
set encoding=utf-8
set mouse=a " Scroll with mouse
set visualbell
"set timeoutlen=500
set cursorline
set scrolloff=5


" Syntax highlighting
let python_highlight_all=1
syntax on
" Unset background color to use iTerm background color instead
" (must be set after enabling syntax highlighting)
highlight Normal ctermbg=NONE
" Highlight matching () {} []
set showmatch
let g:rainbow_active = 1
" Highlight search results
set hlsearch
nnoremap <leader>. :set hlsearch!<cr>


" Search settings
set incsearch " Search while typing
set ignorecase
set smartcase


" Line numbers
set number
"set relativenumber
highlight CursorLineNr ctermfg=2 ctermbg=NONE cterm=NONE


" Copy & Paste from a system buffer
vnoremap <leader>c "*y
noremap <leader>v "*P


" Show/hide whitespaces
set lcs+=space:⥗
nnoremap <leader>w :set list!<CR>
" Highlight redundant whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/


" Block folding
set foldmethod=indent
set foldlevel=99
map <leader>f za
nnoremap <leader>F zM
nnoremap <leader>FF zR


" Code comments
let g:NERDDefaultAlign = 'both'
map <leader>/ <plug>NERDCommenterToggle


" Merge conflicts
nnoremap <leader>cj :/<<<<<<<<CR>
nnoremap <leader>ck :?<<<<<<<<CR>


" Shortcuts
map <F1> :!<CR>
map <F2> :!!<CR>
" Run Python with the current file or wait for args
map <F3> :w<CR>:!python %<CR>
map <F4> :w<CR>:!python % 
map <leader>r :w<CR>:!python %<CR>
map <leader>R :w<CR>:!python % 

" Map Special-Key (Insert) to F4
" iTerm -> Keys -> Send Escape Sequence: 02P
"map <S-F1> <F4>


" Powerline
set guifont=MesloLGS\ NF:h13
let g:powerline_pycmd = 'py3'
let g:Powerline_symbols = 'fancy'
set t_Co=256
set laststatus=2
set noshowmode
let g:airline_powerline_fonts = 1


" Ack
cnoreabbrev Ack Ack!
nnoremap <leader>a :Ack!<space>


" YouCompleteMe
" Auto-completion
let g:ycm_java_binary_path = systemlist('brew --prefix openjdk@17')[0] . '/bin/java'
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>
" Errors navigation (YCM + ListToggle)
let g:ycm_always_populate_location_list = 1
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'
let g:lt_height = 6
noremap <leader>j :lnext<CR>
noremap <leader>k :lprevious<CR>


" Objects Explorer (Tagbar)
nnoremap <silent> <leader>e :TagbarToggle<CR>
let g:tagbar_position = 'topleft vertical'
let g:tagbar_map_togglefold = ["o", "za", "<leader>f"]
let g:tagbar_compact = 1
let g:tagbar_show_tag_linenumbers = 1
let g:tagbar_show_tag_count = 1
let g:tagbar_zoomwidth = 0


" File Browser (NERDTree)
let NERDTreeIgnore=['\.pyc$', ]
let g:NERDTreeLimitedSyntax = 1
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
nnoremap <leader>b :call NERDTreeFindOrToggle()<CR>
function! NERDTreeFindOrToggle()
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    execute("NERDTreeClose")
  else
    let s = execute("NERDTreeFind")
    if strtrans(s) == "^@NERDTree: no file for the current buffer"
      execute("NERDTreeToggle")
    endif
  endif
endfunction


" FZF
set rtp+=/opt/homebrew/opt/fzf
map <leader>t :call FZFWithDevIcons()<CR>
function! FZFWithDevIcons()
  let l:files_limit = 3000 " higher values can slow down the command
  let l:fzf_files_options = ' -m --bind ctrl-f:preview-page-down,ctrl-b:preview-page-up --preview "bat --color always --style numbers {2..}"'

  function! s:files()
    let files = split(system($FZF_VIM_COMMAND), '\n')
    return s:prepend_icon(l:files)
  endfunction

  function! s:prepend_icon(candidates)
    let result = []
    for candidate in a:candidates
      let filename = substitute(candidate, '\e\[[0-9;]\{-}m', '', 'g')
      let filename = fnamemodify(filename, ':p:t')
      let icon = WebDevIconsGetFileTypeSymbol(filename, isdirectory(filename))
      call add(result, printf("%s %s", icon, candidate))
    endfor

    return result
  endfunction

  function! s:edit_file(items)
    let items = a:items
    let i = 1
    let ln = len(items)
    while i < ln
      let item = items[i]
      let parts = split(item, ' ')
      let file_path = get(parts, 1, '')
      let items[i] = file_path
      let i += 1
    endwhile
    call s:Sink(items)
  endfunction

  let counter = len(split(system($FZF_VIM_COMMAND . ' --max-results ' . l:files_limit), '\n'))
  if counter >= l:files_limit
    call fzf#run(fzf#wrap({}))
  else
    let opts = fzf#wrap({})
    let opts.source = <sid>files()
    let s:Sink = opts['sink*']
    let opts['sink*'] = function('s:edit_file')
    let opts.options .= l:fzf_files_options
    call fzf#run(opts)
  endif
endfunction


" GitGutter
"nmap ]h <Plug>(GitGutterNextHunk)
"nmap [h <Plug>(GitGutterPrevHunk)
nmap <leader>hj <Plug>(GitGutterNextHunk)
nmap <leader>hk <Plug>(GitGutterPrevHunk)
nmap <leader>ha <Plug>(GitGutterStageHunk)
nmap <leader>hr <Plug>(GitGutterUndoHunk)
nnoremap <leader>hf :GitGutterFold<CR>
nnoremap <leader>hh :GitGutterLineHighlightsToggle<CR>

highlight SignColumn ctermbg=NONE
highlight LineNr ctermbg=NONE
highlight CursorLineNr ctermbg=NONE

"function! SignColumnToggleTrigger() abort
"  let visible = &signcolumn ==# 'yes'
"  if &signcolumn ==# 'auto'
"    let visible = len(sign_getplaced('%', {'group': '*'})[0].signs)
"  endif
"  if visible
"    highlight LineNr ctermbg=NONE
"    highlight CursorLineNr ctermbg=NONE
"    augroup numbertoggle
"        autocmd!
"        autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu | hi CursorLineNr ctermfg=2 ctermbg=NONE cterm=NONE | endif
"        autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &nu | set nornu | hi CursorLineNr ctermfg=11 ctermbg=NONE cterm=underline | endif
"    augroup END
"  else
"    " Distinct background for LineNr if no SignColumn
"    highlight LineNr ctermbg=0
"    highlight CursorLineNr ctermbg=0
"    augroup numbertoggle
"        autocmd!
"        autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu | hi CursorLineNr ctermfg=2 ctermbg=0 cterm=NONE | endif
"        autocmd BufLeave,FocusLost,InsertEnter,WinLeave * if &nu | set nornu | hi CursorLineNr ctermfg=11 ctermbg=NONE cterm=underline | endif
"    augroup END
"  endif
"endfunction

"augroup SignColumnToggleTrigger
"  autocmd!
"  autocmd BufEnter,BufWinEnter * call SignColumnToggleTrigger()
"  autocmd User GitGutter call SignColumnToggleTrigger()
"augroup END


" vim-go
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'


" Swap & backup files
"
" Store .swp files in ~/.vim/swap
if filewritable("$HOME/.vim/swap") != 2 && (has("unix") || has("win32unix"))
  call system("mkdir -p -m 0700 $HOME/.vim/swap")
endif
set dir=$HOME/.vim/swap

function! s:DeleteOldBackups()
  let l:DayTreshold = 45
  let l:Old = (60 * 60 * 24 * l:DayTreshold)
  let l:BackupFiles = split(glob(&backupdir."*", 1)."\n".glob(&backupdir.".[^.]*",1), "\n")
  let l:Now = localtime()

  for l:File in l:BackupFiles
    if (l:Now - getftime(l:File)) > l:Old
      echon "- Deleting backup file (older than " l:DayTreshold " days): " l:File
      call delete(l:File)
      echon "\t[Done]\n"
    endif
  endfor
endfunction

" Delete backups over 45 days old on exit
au VimLeave * call <SID>DeleteOldBackups()

" Timestamped backups
au BufWritePre * let &backupext = '.bak' . localtime()

" Store .bak files in ~/.vim/backup
if filewritable("$HOME/.vim/backup") != 2 && (has("unix") || has("win32unix"))
  call system("mkdir -p -m 0700 $HOME/.vim/backup")
endif
set backup
set backupdir=$HOME/.vim/backup// " double trailing slash to rename backup file with full path
set backupext=.bak
set backupcopy=yes
set writebackup


" Filetypes (Golang set by vim-go plugin)
set textwidth=0
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent

autocmd Filetype python,php setlocal
    \ textwidth=79
    \ fileformat=unix

" Go set by vim-go plugin
"autocmd Filetype go setlocal
"    \ softtabstop=0
"    \ noexpandtab

autocmd Filetype sh,javascript,typescript,html,css,htmldjango,sql setlocal
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2

autocmd Filetype proto setlocal
    \ textwidth=80
    \ tabstop=2
    \ softtabstop=2
    \ shiftwidth=2
    \ smartindent

autocmd Filetype make setlocal
    \ noexpandtab

autocmd Filetype markdown setlocal
    \ textwidth=79
    \ noautoindent
