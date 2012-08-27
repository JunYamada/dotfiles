"---------------------------------------------------
" �����R�[�h�֘A
" via@https://github.com/cosmo0920/vim-emacs_Setting/tree/master/vimrc
"---------------------------------------------------
if &encoding !=# 'utf-8'
	set encoding=japan
	set fileencoding=japan
endif
if has('iconv')
	let s:enc_euc = 'euc-jp'
	let s:enc_jis = 'iso-2022-jp'
	" iconv��eucJP-ms�ɑΉ����Ă��邩���`�F�b�N
	if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'eucjp-ms'
		let s:enc_jis = 'iso-2022-jp-3'
	" iconv��JISX0213�ɑΉ����Ă��邩���`�F�b�N
	elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
		let s:enc_euc = 'euc-jisx0213'
		let s:enc_jis = 'iso-2022-jp-3'
	endif
	" fileencodings���\�z
	if &encoding ==# 'utf-8'
		let s:fileencodings_default = &fileencodings
		let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
		let &fileencodings = &fileencodings .','. s:fileencodings_default
		unlet s:fileencodings_default
	else
		let &fileencodings = &fileencodings .','. s:enc_jis
		set fileencodings+=utf-8,ucs-2le,ucs-2
		if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
			set fileencodings+=cp932
			set fileencodings-=euc-jp
			set fileencodings-=euc-jisx0213
			set fileencodings-=eucjp-ms
			let &encoding = s:enc_euc
			let &fileencoding = s:enc_euc
		else
			let &fileencodings = &fileencodings .','. s:enc_euc
		endif
	endif
	" �萔������
	unlet s:enc_euc
	unlet s:enc_jis
endif
" ���{����܂܂Ȃ��ꍇ�� fileencoding �� encoding ���g���悤�ɂ���
if has('autocmd')
	function! AU_ReCheck_FENC()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding=&encoding
		endif
	endfunction
"	autocmd BufReadPost * call AU_ReCheck_FENC()
	autocmd BufReadPost *
    	\ if line("'\"") > 1 && line("'\"") <= line("$") |
    	\   exe "normal! g`\"" |
    	\ endif
endif

"----------------------------------------------------
" �C���f���g�E�^�u
" via@https://github.com/cosmo0920/vim-emacs_Setting/tree/master/vimrc
"----------------------------------------------------
" �I�[�g�C���f���g��L���ɂ���
" via@http://nanasi.jp/articles/howto/note/top10-viuser-need-to-know-about-vim.html#cindent
set cindent
" �^�u�̋󔒂̐�
" via@http://ogawa.s18.xrea.com/fswiki/wiki.cgi?page=Vim%A4%CE%A5%E1%A5%E2
set tabstop=4
" tab�������̃J�[�\���ړ���
set softtabstop=4
" �����C���f���g��
set shiftwidth=4


"�����\��(�F�t��)��ON/OFF�ݒ�
if has("syntax")
	syntax on
endif
filetype on
" �E�B���h�E�̕���蒷���s�͐܂�Ԃ��āA���̍s�ɑ����ĕ\������
set wrap
" �����Ȃ������̕\��
" via@http://d.hatena.ne.jp/potappo2/20061107/1162862536
set list
set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<


"------------------------------------------------
"�G�f�B�^�̓���
" via@https://github.com/cosmo0920/vim-emacs_Setting/tree/master/vimrc
"------------------------------------------------
" �s�ԍ���\������
set number
" ���ʓ��͎��̑Ή����銇�ʂ�\��
set showmatch
"�V�����s��������Ƃ��ɍ��x�Ȏ����C���f���g���s��
set smartindent
"�������ɑ啶�����܂�ł������/�������
set smartcase
" �������t�@�C�������܂Ői�񂾂�A�t�@�C���擪����Ăь�������B�i�L��:wrapscan/����:nowrapscan�j
set wrapscan
" �J�[�\�������s�ڂ̉���ڂɒu����Ă��邩��\������B�i�L��:ruler/����:noruler�j
set ruler
" IME��on�̏ꍇ�̓J�[�\����Ԃ�����
" http://www.e2esound.com/wp/2010/11/07/add_vimrc_settings/
hi CursorIM  guifg=black  guibg=red  gui=NONE  ctermfg=black  ctermbg=white  cterm=reverse
" �o�b�N�A�b�v�t�@�C�������Ȃ�
set nobackup
" �X���b�v�t�@�C�����쐬���Ȃ�
set noswapfile
" �������ɑ啶���E����������ʂ��Ȃ�
set ignorecase
" via@http://vimwiki.net/?'guioptions'
" �N���b�v�{�[�h���L
set guioptions=a
" �o�b�N�X�y�[�X��indent���� & ���s�����ăo�b�N�X�y�[�X����
set guioptions=indent,eol
" �J�[�\���s����ʒ����ɂ���
set scrolloff=999
" fullscreen
" via@http://nanabit.net/blog/2007/11/01/vim-fullscreen/
"-----------------------------------------------------------
nnoremap <F11> :call ToggleFullScreen()<CR>
function! ToggleFullScreen()
  if &guioptions =~# 'C'
    set guioptions-=C
    if exists('s:go_temp')
      if s:go_temp =~# 'm'
        set guioptions+=m
      endif
      if s:go_temp =~# 'T'
        set guioptions+=T
      endif
    endif
    simalt ~r
  else
    let s:go_temp = &guioptions
    set guioptions+=C
    set guioptions-=m
    set guioptions-=T
    simalt ~x
  endif
endfunction
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions-=b



"------------------------------------------------
" Plugins
"------------------------------------------------

" javascript-vim
" js�̃C���f���g�␳
" http://github.com/pangloss/vim-javascript
"autocmd FileType javascript
"\ :setl omnifunc=jscomplete#CompleteJS

" neocomplcache
" code�ۊǂ�\������
" https://github.com/Shougo/neocomplcache
" let g:neocomplcache_enable_at_startup = 1
" �d���̂ňꎞ��~


" NERD-Tree
" �����Ȃ��N������Tree�\��
" http://kokukuma.blogspot.jp/2011/12/vim-essential-plugin-nerdtree.html
let file_name = expand("%")
if has('vim_starting') &&  file_name == ""
    autocmd VimEnter * NERDTree ./
endif
" ����
let NERDTreeWinSize = 40





