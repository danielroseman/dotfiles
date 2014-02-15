#! /bin/sh
FILES="vimrc bashrc inputrc"
SOURCE=$PWD
TARGET=$HOME

for f in $FILES; do
	ln -sf $SOURCE/$f $TARGET/.$f;
done
