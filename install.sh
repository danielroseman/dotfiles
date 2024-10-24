#! /bin/sh
FILES="zshrc gitconfig gitattributes gitignore_global pryrc ripgreprc"
SOURCE=$PWD
TARGET=$HOME

for f in $FILES; do
	ln -sf $SOURCE/$f $TARGET/.$f;
done
CONFIGS="nvim atuin"
ln -sf $SOURCE/config/nvim ~/.config/nvim
for f in $CONFIGS; do
	ln -sf $SOURCE/config/$f $TARGET/.config/.$f;
done

echo "installing extra packages"
nix-env -iA nixpkgs.delta
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

ln -s $(which fdfind) ~/.local/bin/fd
ln -s $(which batcat) ~/.local/bin/bat
ln -s $HOME/.pyenv/bin/pyenv ~/.local/bin/pyenv
ln -s $HOME/.atuin/bin/atuin ~/.local/bin/atuin

echo "creating nvim virtualenv"
pyenv virtualenv py3nvim
$(pyenv prefix py3nvim)/bin/pip install -r config/nvim/requirements.txt

echo "installing vim-plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "installing nvim plugins"
nvim -es -i NONE -u config/nvim/init.vim -c "PlugInstall" -c "qa"
echo "done"

