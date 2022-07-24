#!/bin/sh

git clone --bare https://github.com/bxsx/dotfiles ${HOME}/.dotfiles

function config {
	git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME} $@
}

config checkout

# Backup existing dotfiles
if [ $? != 0 ]; then
	echo "Backing up pre-existing dot files."
	config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | while read -r dotfile; do
		mkdir -p ${HOME}/.dotfiles-backup/$(dirname ${dotfile})
		mv ${HOME}/${dotfile} ${HOME}/.dotfiles-backup/${dotfile}
		echo "${dotfile}\t\t\t\tBACKUPED!"
	done
	config checkout
fi

# Track only checked-in files
config config status.showUntrackedFiles no
# Enable rebase policy
config config pull.rebase true

echo "Checked out config."
