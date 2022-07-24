#!/bin/sh

git clone --bare https://github.com/bxsx/dotfiles ${HOME}/.dotfiles

function config {
	git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} $@
}

mkdir -p ${HOME}/.dotfiles-backup
config checkout
if [ $? = 0 ]; then
	echo "Checked out config."
else
	echo "Backing up pre-existing dot files."
	config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ${HOME}/.dotfiles-backup/{}
	config checkout
fi
config config status.showUntrackedFiles no
