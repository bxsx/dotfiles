# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
ZSH_THEME="powerlevel10k/powerlevel10k"

HIST_STAMPS="yyyy-mm-dd"
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
setopt hist_ignore_dups
setopt hist_ignore_space

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

zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 33


### Custom required pre-OMZ! init configuration
# Must be set before sourcing Oh-my-zsh
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# show groups for cd/pushd
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories path-directories'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# remove redudant prefix for each item
zstyle ':fzf-tab:*' prefix ''
# fzf-preview for tab completation
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:vim:*' fzf-preview 'bat --color=always --style=numbers $realpath'
# key-bindings:
# - restore default multiselect fzf binding (<tab>)
# - accept selection on <space> (and <enter>)
# - accept selection and continue in the sub-path (<\>)
zstyle ':fzf-tab:complete:*' fzf-bindings 'shift-tab:toggle+down,space:accept'
zstyle ':fzf-tab:complete:*' continuous-trigger '\'

# Node.js Version Manager
# Must be set before loading zsh-nvm plugin (which installs `nvm`)
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true


plugins=(
	aws
	git
	docker
	docker-compose
	terraform
	golang
	poetry
	zsh-nvm
	timewarrior
	fzf-tab
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

#export CLICOLOR=1
#export TERM=xterm-256color

# fix invisible colors
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=10
export ZSH_HIGHLIGHT_STYLES[comment]=fg=8


### User configuration
# `git clone --bare https://github.com/bxsx/dotfiles ${HOME}/.dotfiles`
alias config="git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}"

export DEVDIR="$HOME/+dev"
export PATH="$DEVDIR/scripts/bin:$PATH"
export CDPATH=.:..:...:$HOME:$DEVDIR
#export ARCHFLAGS="-arch arm64"

#function cd() {
#        if [ "$#" = "0" ]; then
#                pushd ${HOME} > /dev/null
#        elif [ -f "${1}" ]; then
#                ${EDITOR} {$1}
#        else
#                pushd "$1" > /dev/null
#        fi
#}

#function bd() {
#        if [ "$#" = "0" ]; then
#                popd > /dev/null
#        else
#                for i in $(seq ${1})
#                do
#                        popd > /dev/null
#                done
#        fi
#}

# iTerm
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Homebrew
export HOMEBREW_NO_ENV_HINTS=true
eval "$(/opt/homebrew/bin/brew shellenv)"

# GNU utils (instead of POSIX)
#SED=$(brew --prefix gnu-sed) && test -d $SED && export PATH="$SED/libexec/gnubin:$PATH"
#GREP=$(brew --prefix grep) && test -d $GREP && export PATH="$GREP/libexec/gnubin:$PATH"
#FINDUTILS=$(brew --prefix findutils) && test -d $FINDUTILS && export PATH="$FINDUTILS/libexec/gnubin:$PATH"
#COREUTILS=$(brew --prefix coreutils) && test -d $COREUTILS && export PATH="$COREUTILS/libexec/gnubin:$PATH"
#unset COREUTILS FINDUTILS GREP SED

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
              GDBM_CFLAGS=\"-I$(brew --prefix gdbm)/include\" \
              GDBM_LIBS=\"-L$(brew --prefix gdbm)/lib -lgdbm\" \
              ./configure --with-pydebug --with-openssl="$(brew --prefix openssl@3.0)" \
              && make -s -j$(python3 -c 'import os; print(os.cpu_count() + 2)')"

# Go
export GOPRIVATE=github.com/bxsx
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

# Perl
eval "$(perl -I$HOME/.perl5/lib/perl5 -Mlocal::lib=$HOME/.perl5)"

# Git
# Use completions provided by ZSH instead of Git
[[ -L "$(brew --prefix)/share/zsh/site-functions/_git" ]] && rm "$(brew --prefix)/share/zsh/site-functions/_git"

unalias gsr # disable oh-my-zsh git svn rebase
unalias gsd # disable oh-my-zsh git svn dcommit
alias glf="git log --oneline | fzf --multi --preview 'git show {+1} --color=always'"
alias glr="git pull --rebase"
alias gcof="glf | cut -d' ' -f1 | xargs git checkout"
alias grhs="git reset --soft"
alias grhs1="git reset --soft HEAD~1"
alias gbv="git branch -v"
alias gbva="git branch -v -a"
alias gamsoff="git am --signoff"
alias gstats="git log --shortstat --author='Bart Skowron' | grep -E 'fil(e|es) changed' | awk '{files+=\$1; inserted+=\$4; deleted+=\$6; delta+=\$4-\$6; ratio=deleted/inserted} END {printf \"Commit stats:\n- Files changed (total)..  %s\n- Lines added (total)....  %s\n- Lines deleted (total)..  %s\n- Total lines (delta)....  %s\n- Add./Del. ratio (1:n)..  1 : %s\n\", files, inserted, deleted, delta, ratio }' -"

# PostgreSQL
export PATH="$(brew --prefix libpq)/bin:$PATH"

# FZF
export FZF_DEFAULT_COMMAND="fd --type f --color=always"
export FZF_DEFAULT_OPTS="--ansi --multi --height 40% --marker='+' --tabstop=4 --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up"

FZF_EXCLUDED="-E .git -E .mypy_cache -E .pytest_cache -E __pycache__ -E '*.pyc'"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND -I $FZF_EXCLUDED"
export FZF_CTRL_T_OPTS="--preview='bat --color=always --style=numbers {}'"

export FZF_ALT_C_COMMAND="fd --type d --hidden --color=always -I $FZF_EXCLUDED"
export FZF_ALT_C_OPTS="--preview='eza -1 --color=always {}'"

export FZF_VIM_COMMAND="${FZF_DEFAULT_COMMAND} --hidden $FZF_EXCLUDED"

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
export LESS="--quit-at-eof --quit-if-one-screen --no-init $LESS"
export LANG="en_US.UTF-8"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
#export SLACK_DEVELOPER_MENU=true
if [[ -d "/Applications/Wireshark.app" ]]; then
  export PATH="$PATH:/Applications/Wireshark.app/Contents/MacOS"
fi

eval "$(direnv hook zsh)"
#. ${HOME}/.vim/bundle/powerline/powerline/bindings/zsh/powerline.zsh

# Aliases
alias v=vim
alias py=python
alias ip=ipython
alias dc=docker-compose
alias k=kubectl
alias kns=kubens
alias kctx=kubectx
alias colordiff="colordiff -u"
alias worddiff="git diff -U0 --word-diff --no-index --"
alias du="du -h"
alias ncdu="ncdu --color dark"
alias htop="sudo htop"
alias nproc="sysctl -n hw.logicalcpu"

if command -v bat &> /dev/null; then
	export BAT_THEME="Solarized (dark)"
	export BAT_STYLE="numbers"
#	alias cat="bat --paging=never"
fi
if command -v eza &> /dev/null; then
	alias ls="eza"
	alias lt="ls --tree --icons"
	alias la="eza -a"
	alias lat="la --tree --icons"
	alias ll="eza -lg --icons"
	alias llt="ll --tree"
	alias l="ll -a"
fi
if command -v duf &> /dev/null; then
	alias df="duf"
fi

# Shortcuts
alias wiki="jupyter-lab"
alias wikiinit="jupytext --set-formats ipynb,py"
alias garminsync="garminsync $HOME/Documents/bike/activities $DEVDIR/opensource/garmin-connect-export prod"
alias dnscheck="dig @8.8.8.8 \$1 ANY +noall +answer"
alias airplayrestart="sudo killall coreaudiod AirPlayXPCHelper"


function kpod() {
	kubectl create -f- <<-EOF
	---
	apiVersion: v1
	kind: Pod
	metadata:
	  name: bart-sh
	spec:
	  containers:
	  - name: shell
	    image: ${1:-python:alpine}
	    command: ['sh']
	    args: ['-c', 'while true; do sleep 3600; done']
	EOF
}


function omz-update-custom() {
	pushd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
	for plugin in plugins/*/ themes/*/; do
		if [[ -d "$plugin/.git" ]]; then
			printf "${YELLOW}%s${RESET}\n" "${plugin%/}"
			git -C "$plugin" pull
		fi
	done
	popd
}

# External configs
[[ -f ~/.zshrc-external ]] && source ~/.zshrc-external
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
