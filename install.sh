#! /bin/sh
FILES="zshrc gitconfig gitattributes gitignore_global pryrc ripgreprc"
SOURCE=$PWD
TARGET=$HOME

for f in $FILES; do
	ln -sf $SOURCE/$f $TARGET/.$f;
done
ln -sf $PWD/config/nvim ~/.config/nvim

curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

nvim -es -i NONE -c "PlugInstall" -c "qa"
