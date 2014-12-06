" <Leader>はバックスラッシュ

" [Vim の種類 (Vim family) - Qiita](http://qiita.com/b4b4r07/items/f7a4a0461e1fc6f436a4)
if !1 | finish | endif


" Variables
" ================================================================================

" OS判別
" --------------------------------------------------------------------------------
if has("mac")
    let OS_NAME='mac'
elseif has("unix")
    let OS_NAME='unix'
elseif has("win64")
    let OS_NAME='win64'
elseif has("win32unix")
    " minGW/Cygwin固有の設定
    let OS_NAME='win32unix'
elseif has("win32")
    let OS_NAME='win32'
endif


" plugin (NeoBundle is required)
" ================================================================================

if has('vim_starting')
    set nocompatible               " Be iMproved

    " 普通に`set runtimepath+=~/.vim/bundle/neobundle.vim/`すると
    " windowsでうまくシンボリックリンク元を探ってくれなかったので
    " expandし実体へのフルパス指定
    if &runtimepath !~ '/neobundle.vim'
        execute 'set runtimepath+=' . expand('~/Dotfiles/.vim/bundle/neobundle.vim/')
    endif
endif

" Required:
call neobundle#begin(expand('~/Dotfiles/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'


set runtimepath+=~/Dotfiles/vimrc.d/
runtime! plugins/*.vim


call neobundle#end()

" Required:
filetype plugin indent on

" 未インストールpluginがないか確認
NeoBundleCheck



" Basic Setup
" ================================================================================
source ~/dotfiles/vimrc.d/basic.vim


" Visual Settigns
" ================================================================================
source ~/dotfiles/vimrc.d/visual.vim


" Mappings
" ================================================================================
source ~/dotfiles/vimrc.d/mapping.vim


" Autocmd Rules
" ================================================================================
source ~/dotfiles/vimrc.d/autocmd.vim


" Functions
" ================================================================================
source ~/dotfiles/vimrc.d/function.vim

