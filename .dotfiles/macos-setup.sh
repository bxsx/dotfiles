#!/bin/bash

# 1. Install and activate HomeBrew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Install formulae

brew install git zsh fzf eza fd bat direnv

# 3. Install pipx

brew install pipx
pipx install argcomplete

# 4. Install Perl

brew install perl
PERL_MM_OPT="INSTALL_BASE=$HOME/.perl5" cpan local::lib

# 5. Install .dotfiles

[[ -f install.sh ]] && ./install.sh

# 6. Set up Zsh

[[ -f zsh-setup.sh ]] && ./zsh-setup.sh

# 7. Set up VIm

brew install --cask macvim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
/opt/homebrew/bin/vim +PluginInstall +qall

## YouCompleteMe
brew install pyenv
eval "$(pyenv init - zsh)"
pyenv install 3
pyenv latest 3 | xargs -I{} pyenv global {} system
pip install setuptools

brew install cmake go nodejs openjdk
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

$HOME/.vim/bundle/YouCompleteMe/install.py --all

# 8. Set default shell
CUSTOM_SHELL=/opt/homebrew/bin/zsh
grep -q "$CUSTOM_SHELL" /etc/shells || sudo sh -c "echo $CUSTOM_SHELL >> /etc/shells"
sudo chsh -s "$CUSTOM_SHELL" "$(whoami)"

# 9. Install iTerm2
brew install iterm2
curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash

echo "Done."
