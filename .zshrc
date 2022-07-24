# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_CUSTOM="$HOME/.zcustom"

COMPLETION_WAITING_DOTS="true"
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
#
# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

zstyle ':omz:update' mode auto      # update automatically without asking (other options: disabled, reminder)
zstyle ':omz:update' frequency 33


### Custom required pre-OMZ! init configuration
# Must be set before sourcing Oh-my-zsh
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# remove redudant prefix for each item
zstyle ':fzf-tab:*' prefix ''
# fzf-preview for tab completation
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:vim:*' fzf-preview 'bat --color=always --style=numbers $realpath'
# key-bindings:
# - restore default multiselect fzf binding (<tab>)
# - accept selection on <space> (and <enter>)
zstyle ':fzf-tab:*' fzf-bindings 'tab:toggle+down,space:accept'

# Node.js Version Manager
# Must be set before loading zsh-nvm plugin
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true


plugins=(
	git
	docker
	docker-compose
	golang
	poetry
	zsh-nvm
	timewarrior
	fzf-tab
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10' # fix invisible color


### User configuration
# `git clone --bare https://github.com/bxsx/dotfiles ${HOME}/.dotfiles`
alias config="git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}"

export DEVDIR="$HOME/+dev"
export PATH="$PATH:$DEVDIR/scripts/bin"
#export ARCHFLAGS="-arch arm64"

# iTerm
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

## Python
# PIPX
export PATH="$HOME/.local/bin:$PATH"
eval "$(register-python-argcomplete pipx)"

# PyEnv
export PYENV_ROOT="$HOME/.pyenv"
export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi
if which pyenv-virtualenv-init > /dev/null; then
  eval "$(pyenv virtualenv-init -)"
fi
#alias pyenv-poetry="$DEVDIR/scripts/pyenv-poetry/pyenv-poetry.sh"

# CPython
# Configure to compile Python in debug mode:
# - use -C to use a config.cache in the current directory
# - force -O0 (instead of -Og) for best debug experience (in gdb)
# - use --with-pydebug to compile python in debug mode.
#alias pyconfigure_debug="./configure --cache-file=../python-config.cache --with-pydebug CFLAGS=-O0 --with-system-expat --with-system-ffi"
alias makepy="make clean && \
              PKG_CONFIG_PATH=\"$(brew --prefix tcl-tk)/lib/pkgconfig\" \
              LDFLAGS=\"-L$(brew --prefix gdbm)/lib\" \
              CFLAGS=\"-I$(brew --prefix gdbm)/include\" \
              ./configure --with-pydebug --with-openssl=$(brew --prefix openssl@1.1) && \
	      make -s -j$(python3 -c 'import os; print(os.cpu_count() + 2)')"

# Go
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"

# Perl
eval "$(perl -I$HOME/.perl5/lib/perl5 -Mlocal::lib=$HOME/.perl5)"

# NVM (more in headers)
NVM_COMPLETION="$(brew --prefix nvm)/etc/bash_completion.d/nvm"; [ -s $NVM_COMPLETION ] && source $NVM_COMPLETION

# Git
unalias gsr # disable oh-my-zsh git svn rebase
unalias gsd # disable oh-my-zsh git svn dcommit
alias glf="git log --oneline | fzf --multi --preview 'git show {+1} --color=always'"
alias grhs="git reset --soft"
alias grhs1="git reset --soft HEAD~1"
alias gbv="git branch -v"
alias gbva="git branch -v -a"
alias gamsoff="git am --signoff"
alias gstats="git log --shortstat --author='Bart Skowron' | grep -E 'fil(e|es) changed' | awk '{files+=\$1; inserted+=\$4; deleted+=\$6; delta+=\$4-\$6; ratio=deleted/inserted} END {printf \"Commit stats:\n- Files changed (total)..  %s\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n\", files, inserted, deleted, delta, ratio }' -"

# FZF
export FZF_DEFAULT_COMMAND="fd --type f --color=always"
export FZF_DEFAULT_OPTS="--ansi --multi --height 40% --marker='+' --tabstop=4 --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up"

FZF_EXCLUDED="-E .git -E .mypy_cache -E .pytest_cache -E __pycache__ -E '*.pyc'"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND -I $FZF_EXCLUDED"
export FZF_CTRL_T_OPTS="--preview='bat --color=always --style=numbers {}'"

export FZF_ALT_C_COMMAND="fd --type d --color=always -I $FZF_EXCLUDED"
export FZF_ALT_C_OPTS="--preview='exa -1 --color=always {}'"


if [[ -f ~/.fzf.zsh ]]; then
  source ~/.fzf.zsh

  # Default key bindings:
  #   CTRL-T                   - paste the selected files and directories onto the command-line
  #   CTRL-R                   - paste the selected command from history onto the command-line
  #   ALT-C | ESC-C            - cd into the selected directory (start searching from `cwd`)
  # Custom key bindings:
  #   SHIFT-ALT-C | SHIT-ESC-C - cd into the selected directory (start searching from / (or $HOME))
  fzf-cd-root-widget() {
    local FZF_ALT_C_COMMAND="$FZF_ALT_C_COMMAND . /" # $HOME
    fzf-cd-widget
  }
  zle     -N             fzf-cd-root-widget
  bindkey -M emacs '\eC' fzf-cd-root-widget
  bindkey -M vicmd '\eC' fzf-cd-root-widget
  bindkey -M viins '\eC' fzf-cd-root-widget
fi


# Other
export EDITOR=vim
export LESS="-e -F -X $LESS" # e:--quit-at-eof F:--quit-if-one-screen X:--no-init
export LANG="en_US.UTF-8"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
#export SLACK_DEVELOPER_MENU=true
if [[ -d "/Applications/Wireshark.app" ]]; then
  export PATH="$PATH:/Applications/Wireshark.app/Contents/MacOS"
fi

eval "$(direnv hook zsh)"
#. ${HOME}/.vim/bundle/powerline/powerline/bindings/zsh/powerline.zsh

# Aliases
alias py=python
alias ip=ipython
alias dc=docker-compose
alias colordiff="colordiff -u"
alias du="du -h"
alias htop="sudo htop"

if command -v bat &> /dev/null; then
	export BAT_THEME="Solarized (dark)"
	export BAT_STYLE="numbers"
#	alias cat="bat --paging=never"
fi
if command -v exa &> /dev/null; then
	alias ls="exa"
	alias ll="exa -lg"
	alias la="exa -a"
	alias llt="ll --tree"
	alias lat="la --tree"
	alias lt="ls --tree"
	alias l="ll -a"
fi
if command -v duf &> /dev/null; then
	alias df="duf"
fi

# Shortcuts
alias wiki="jupyter-lab --no-browser"
alias wikiinit="jupytext --set-formats ipynb,py"
alias garminsync="garminsync $HOME/Documents/bike/activities $DEVDIR/opensource/garmin-connect-export prod"
alias dnscheck="dig @8.8.8.8 \$1 ANY +noall +answer"
alias airplayrestart="sudo killall coreaudiod AirPlayXPCHelper"


# External configs
[ -f ~/.zshrc-external ] && source ~/.zshrc-external

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
