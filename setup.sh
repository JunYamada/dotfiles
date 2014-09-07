echo "***** [$0] start " `date +'%Y/%m/%d %H:%M:%S'` " *****"

# ベースディレクトリを取得
# =============================================================================
if [ ! -d "$DOTFILES_DIR" ]; then
    DOTFILES_DIR="$(cd $(dirname $0) && pwd)"
    # DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")/.." && pwd)"
fi
DOTFILES_ENV="$DOTFILES_DIR/skel"
DOTFILES_VIM="$DOTFILES_DIR/.vim"

# 移動
cd "$DOTFILES_DIR"



# submodule update
# =============================================================================
git submodule foreach 'git checkout master; git pull'
git submodule update --init


# setup homebrew
# =============================================================================
sh setup_brew.sh


# シンボリックリンク
# =============================================================================
# .vim
ln -sfn "$DOTFILES_ENV/.vim" "$HOME/.vim"
echo "create symbolic link "$DOTFILES_ENV/.vim" > "$HOME/.vim""

# skel内のdotfilesへのシンボリックリンクを~に作成
backupdir="$HOME/dotfiles-backup-`date +%Y%m%dT%H%M%S`"
(
    find "$DOTFILES_ENV" -mindepth 1 -maxdepth 1 -name .\* ! -name .\*.swp
) |
while read src; do
    dest="$HOME/${src##*/}"

    # 既存の実ファイルが存在したらリネームしてとっておく(srcとdestの実体が同じ場合はスキップ)
    if [ -e "$dest" -a ! "$src" -ef "$dest" ]; then
        mkdir -p "$backupdir"
        mv "$dest" "$backupdir/${src##*/}"
    fi

    # シンボリックリンクを作る
    ln -sfn "$src" "$dest"
    echo "create symbolic link "$src" > "$dest" "
done
if [ -d "$backupdir" ]; then
    echo -e "既存のドットファイルは \x1b[36m${backupdir}\x1b[0m に移動されました"
fi



# setup vim
# =============================================================================

# installing NeoBundles
echo "[vim] Installing NeoBundles"
vim -c NeoBundleInstall -c q

# for ref.vim
if [ ! -d "$DOTFILES_VIM/php_manual/php-chunked-xhtml" ]; then
    mkdir -p "$DOTFILES_VIM/php_manual"
    curl -L http://jp.php.net/get/php_manual_ja.tar.gz/from/this/mirror |
    tar xz -C "$DOTFILES_VIM/php_manual"
fi


# setup launch
#     login時に起動
#     apache2.2想定
# =============================================================================
ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents

# ln -sfv /usr/local/opt/httpd24/*.plist ~/Library/LaunchAgents

# via@https://github.com/jaswsinc/homebrew-apache2
if [ ! -d "/Library/LaunchDaemons" ]; then
    mkdir -p "/Library/LaunchDaemons"
fi
sudo cp /usr/local/opt/httpd22/*.plist /Library/LaunchDaemons
# sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.httpd22.plist


