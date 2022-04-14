#! /bin/sh
FILES="vimrc zshrc gitconfig gitattributes gitignore_global pryrc"
SOURCE=$PWD
TARGET=$HOME

for f in $FILES; do
	ln -sf $SOURCE/$f $TARGET/.$f;
done

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"

nix-env -i bat
nix-env -i fd
nix-env -iA nixpkgs.delta
