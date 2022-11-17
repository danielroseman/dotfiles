#! /bin/sh
FILES="zshrc gitconfig gitattributes gitignore_global pryrc ripgreprc"
SOURCE=$PWD
TARGET=$HOME

for f in $FILES; do
	ln -sf $SOURCE/$f $TARGET/.$f;
done
ln -sf $SOURCE/config/nvim ~/.config/nvim

pyenv virtualenv py3nvim
$(pyenv prefix py3nvim)/bin/pip install pynvim jedi-language-server

echo "installing vim-plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "installing nvim plugins"
nvim -es -i NONE -u config/nvim/init.vim -c "PlugInstall" -c "qa"
echo "done"
