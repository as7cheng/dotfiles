# Shihan's zshell source file, edited on Sam's version.
# The path should be '~/.zshrc'
# Environ: path functions {{{

function path_ladd() {
  # Takes 1 argument and adds it to the beginning of the PATH
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1${PATH:+":$PATH"}"
  fi
}

function path_radd() {
  # Takes 1 argument and adds it to the end of the PATH
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="${PATH:+"$PATH:"}$1"
  fi
}

# }}}
# Environ: ls_colors {{{

# Colors when using the LS command
# NOTE:
# Color codes:
#   0   Default Colour
#   1   Bold
#   4   Underlined
#   5   Flashing Text
#   7   Reverse Field
#   31  Red
#   32  Green
#   33  Orange
#   34  Blue
#   35  Purple
#   36  Cyan
#   37  Grey
#   40  Black Background
#   41  Red Background
#   42  Green Background
#   43  Orange Background
#   44  Blue Background
#   45  Purple Background
#   46  Cyan Background
#   47  Grey Background
#   90  Dark Grey
#   91  Light Red
#   92  Light Green
#   93  Yellow
#   94  Light Blue
#   95  Light Purple
#   96  Turquoise
#   100 Dark Grey Background
#   101 Light Red Background
#   102 Light Green Background
#   103 Yellow Background
#   104 Light Blue Background
#   105 Light Purple Background
#   106 Turquoise Background
# Parameters
#   di 	Directory
LS_COLORS="di=1;34:"
#   fi 	File
LS_COLORS+="fi=0:"
#   ln 	Symbolic Link
LS_COLORS+="ln=1;36:"
#   pi 	Fifo file
LS_COLORS+="pi=5:"
#   so 	Socket file
LS_COLORS+="so=5:"
#   bd 	Block (buffered) special file
LS_COLORS+="bd=5:"
#   cd 	Character (unbuffered) special file
LS_COLORS+="cd=5:"
#   or 	Symbolic Link pointing to a non-existent file (orphan)
LS_COLORS+="or=31:"
#   mi 	Non-existent file pointed to by a symbolic link (visible with ls -l)
LS_COLORS+="mi=0:"
#   ex 	File which is executable (ie. has 'x' set in permissions).
LS_COLORS+="ex=1;92:"
# additional file types as-defined by their extension
LS_COLORS+="*.rpm=90"

# Finally, export LS_COLORS
export LS_COLORS

# }}}
# Environ: exported variables {{{

# React
export REACT_EDITOR='less'

# colored GCC warnings and errors
GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01"
GCC_COLORS="$GCC_COLORS;32:locus=01:quote=01"
export GCC_COLORS

# Configure less (de-initialization clears the screen)
# Gives nicely-colored man pages
LESS="--ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS"
LESS="$LESS --HILITE-UNREAD --tabs=4 --quit-if-one-screen"
export LESS
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export PAGER=less

# Configure Man Pager
export MANWIDTH=79
export MANPAGER=less

# Git
export GIT_PAGER=less

# Set default text editor
export EDITOR=nvim

# environment variable controlling difference between HI-DPI / Non HI_DPI
# turn off because it messes up my pdf tooling
export GDK_SCALE=0

# History: How many lines of history to keep in memory
export HISTSIZE=5000

# History: ignore leading space, where to save history to disk
export HISTCONTROL=ignorespace
export HISTFILE=~/.zsh_history

# History: Number of history entries to save to disk
export SAVEHIST=5000

# FZF
export FZF_COMPLETION_TRIGGER=''
export FZF_DEFAULT_OPTS="--bind=ctrl-o:accept --ansi"
FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_COMMAND

# Python virtualenv (disable the prompt so I can configure it myself below)
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Default browser for some programs (eg, urlview)
export BROWSER='/usr/bin/firefox'

# Enable editor to scale with monitor's DPI
export WINIT_HIDPI_FACTOR=1.0

# Bat
export BAT_PAGER=''

# }}}
# Environ: path appends + misc env setup {{{

HOME_BIN="$HOME/bin"
if [ -d "$HOME_BIN" ]; then
  path_ladd "$HOME_BIN"
fi

HOME_BIN_HIDDEN="$HOME/.bin"
if [ ! -d "$HOME_BIN_HIDDEN" ]; then
  mkdir "$HOME_BIN_HIDDEN"
fi
path_ladd "$HOME_BIN_HIDDEN"

HOME_LOCAL_BIN="$HOME/.local/bin"
if [ ! -d "$HOME_LOCAL_BIN" ]; then
  mkdir -p "$HOME_LOCAL_BIN"
fi
path_ladd "$HOME_LOCAL_BIN"

OPAM_LOC="$HOME/.opam/default/bin"
if [ -d "$OPAM_LOC" ]; then
  path_ladd "$OPAM_LOC"
fi

# EXPORT THE FINAL, MODIFIED PATH
export PATH

# }}}
# Imports: script sourcing {{{

function include() {
  [[ -f "$1" ]] && source "$1"
}

include ~/.bash/sensitive
include ~/.config/broot/launcher/bash/br

# }}}
# Z-shell: plugins {{{

if [ -f $HOME/.zplug/init.zsh ]; then
  source $HOME/.zplug/init.zsh

  # BEGIN: List plugins

  # use double quotes: the plugin manager author says we must for some reason
  zplug 'zplug/zplug', hook-build:'zplug --self-manage'
  zplug "greymd/docker-zsh-completion", as:plugin
  zplug "zsh-users/zsh-completions", as:plugin
  zplug "zsh-users/zsh-syntax-highlighting", as:plugin
  zplug "denysdovhan/spaceship-prompt", \
    use:spaceship.zsh, \
    from:github, \
    as:theme
  zplug "junegunn/fzf", use:"shell/*.zsh", defer:2

  #END: List plugins

  # Install plugins if there are plugins that have not been installed
   if ! zplug check --verbose; then
       printf "Install? [y/N]: "
       if read -q; then
           echo; zplug install
       fi
   fi

  # Then, source plugins and add commands to $PATH
  zplug load
else
  echo "zplug not installed, so no plugins available"
fi

# }}}
# Z-shell: options {{{

#######################################################################
# Set options
#######################################################################

# enable functions to operate in PS1
setopt PROMPT_SUBST

# list available directories automatically
setopt AUTO_LIST
setopt LIST_AMBIGUOUS
setopt LIST_BEEP

# completions
setopt COMPLETE_ALIASES

# automatically CD without typing cd
setopt AUTOCD

# Dealing with history
setopt HIST_IGNORE_SPACE
setopt APPENDHISTORY
setopt SHAREHISTORY
setopt INCAPPENDHISTORY

#######################################################################
# Unset options
#######################################################################

# do not automatically complete
unsetopt MENU_COMPLETE

# do not automatically remove the slash
unsetopt AUTO_REMOVE_SLASH

#######################################################################
# Expected parameters
#######################################################################
export PERIOD=1
export LISTMAX=0

# }}}
# Z-shell: misc autoloads {{{

# Enables zshell calculator: type with zcalc
autoload -Uz zcalc

# }}}
# Z-shell: hook functions {{{

# NOTE: precmd is defined within the prompt section

# Executed whenever the current working directory is changed
function chpwd() {
  # Magically find Python's virtual environment based on name
  venv_lookup
}

# Executed every $PERIOD seconds, just before a prompt.
# NOTE: if multiple functions are defined using the array periodic_functions,
# only  one  period  is applied to the complete set of functions, and the
# scheduled time is not reset if the list of functions is altered.
# Hence the set of functions is always called together.
#function periodic() {
  # Magically find Python's virtual environment based on name
#  vaa
#}

# Executed before each prompt. Note that precommand functions are not
# re-executed simply because the command line is redrawn, as happens, for
# example, when a notification about an exiting job is displayed.
#function precmd() {
  # Gather information about the version control system
 # vcs_info
#}

# Executed just after a command has been read and is about to be executed
#   arg1: the string that the user typed OR an empty string
#   arg2: a single-line, size-limited version of the command
#     (with things like function bodies elided)
#   arg3: full text that is being executed
function preexec() {
  # local user_string="$1"
  # local cmd_single_line="$2"
  # local cmd_full="$3"
}


# Executed when a history line is read interactively, but before it is executed
#   arg1: the complete history line (terminating newlines are present
function zshaddhistory() {
  # local history_complete="$1"
}

# Executed at the point where the main shell is about to exit normally.
function zshexit() {
}

# }}}
# Imports: asdf (must be before z-shell autocompletion setup){{{

include $HOME/.asdf/asdf.sh

# }}}
# Z-shell: auto completion {{{

fpath=(${ASDF_DIR}/completions $fpath)
autoload -U compinit && compinit
autoload -U +X bashcompinit && bashcompinit
zstyle ':completion:*:*:git:*' script /usr/local/etc/bash_completion.d/git-completion.bash

# CURRENT STATE: does not select any sort of searching
# searching was too annoying and I didn't really use it
# If you want it back, use "search-backward" as an option
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Fuzzy completion
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-A-Z}={A-Z\_a-z}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-A-Z}={A-Z\_a-z}' \
  'r:|?=** m:{a-z\-A-Z}={A-Z\_a-z}'
fpath=(/usr/local/share/zsh-completions $fpath)
zmodload -i zsh/complist

# Add autocompletion path
fpath+=~/.zfunc

# Add autocompletion for aws-cli v2
complete -C aws_completer aws

# }}}
# Z-shell: compdef testing {{{

# Example from:
# https://mads-hartmann.com/2017/08/06/writing-zsh-completion-scripts.html

function _hello {
  local line

  _arguments -C \
    "-h [Show help information]" \
    "--help[Show help information]" \
    "-v[Print verbose message]" \
    "--verbose[Print verbose message]" \
    "1: :(quietly loudly)" \
    "*::arg:->args"

  case $line[1] in
    loudly)
      _hello_loudly
      ;;
    quietly)
      _hello_quietly
      ;;
  esac
}

function _hello_quietly {
  _arguments "--silent[Dont output anything]"
}

function _hello_loudly {
  _arguments "--yolo=[Do that yolo thang]"
}

function hello() {
  if [[ "$1" = '--help' ]]; then
    echo "There is no help for you here."
  elif [[ "$1" = '--verbose' ]]; then
    echo "There is no verbosity here"
  elif [[ "$1" = 'quietly' ]]; then
    if [[ "$2" = "--silent" ]]; then
      echo "You told me to say it quietly, but I can't!"
    else
      echo "hello"
    fi
  elif [[ "$1" = 'loudly' ]]; then
    if [[ "$2" = "--yolo" ]]; then
      echo "HELLOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"
    else
      echo "HELLO"
    fi
  else
    echo "Hello"
    return 1
  fi
}
compdef _hello hello


# }}}
# Z-shell: key remapping {{{

# emacs
bindkey -e

# NOTE: about menu-complete
# '^d' - list options without selecting any of them
# '^i' - synonym to TAB; tap twice to get into menu complete
# '^o' - choose selection and execute
# '^m' - choose selection but do NOT execute AND leave all modes in menu-select
#         useful to get out of both select and search-backward
# '^z' - stop interactive tab-complete mode and go back to regular selection

# navigate menu with vi keys "hjkl"
bindkey -M menuselect '^j' menu-complete
bindkey -M menuselect '^k' reverse-menu-complete
bindkey -M menuselect '^h' backward-char
bindkey -M menuselect '^l' forward-char

# delete function characters to include
# Omitted: /=
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# }}}
# Z-shell: fzf {{{

# Use fd to generate the list for file and directory completion
_fzf_compgen_path() {
  fd -c always --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
  fd -c always --hidden --type d --follow --exclude ".git" . "$1"
}

# <C-t> does fzf; <C-i> does normal stuff; <C-o> does the same thing as enter
bindkey '^T' fzf-completion
bindkey '^R' fzf-history-widget
bindkey '^B' fzf-file-widget
bindkey '^I' $fzf_default_completion

# Widgets:
# fzf-cd-widget
# fzf-completion
# fzf-file-widget
# fzf-history-widget

# }}}
# Z-shell: shell prompt config {{{

# https://github.com/denysdovhan/spaceship-prompt/blob/master/docs/Options.md

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  venv          # virtualenv section
  line_sep      # Line break
  char          # Prompt character
)

SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL='$ '
SPACESHIP_DIR_PREFIX=
SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_HOST_COLOR=yellow
SPACESHIP_HOST_PREFIX=@
SPACESHIP_HOST_SHOW=true
SPACESHIP_USER_COLOR=yellow
SPACESHIP_USER_SHOW=true
SPACESHIP_USER_SUFFIX=
SPACESHIP_VENV_PREFIX='('
SPACESHIP_VENV_SUFFIX=')'
SPACESHIP_VENV_GENERIC_NAMES=()
SPACESHIP_CHAR_COLOR_SUCCESS=green
SPACESHIP_CHAR_COLOR_FAILURE=green

# }}}
# General: post-asdf env setup {{{

# NOTE: currently commented out because this slows down zsh load a lot
# MANPATH: add asdf man pages to my man path
# MANPATH="$HOME/man"
# if [ -x "$(command -v fd)" ]; then
#   for value in $(fd man1 ~/.asdf/installs --type directory | sort -hr); do
#     MANPATH="$MANPATH:$(dirname $value)"
#   done
#   # colon at end. See "man manpath"
#   export MANPATH="$MANPATH:"
# fi

# include ~/.asdf/plugins/java/set-java-home.sh

# }}}
# General: aliases {{{

# Easier directory navigation for going up a directory tree
alias 'a'='cd - &> /dev/null'
alias 'cd..'='cd_up'  # can not name function 'cd..'; references cd_up below
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'
alias ...........='cd ../../../../../../../../../..'

# Restart Xserver (go to a tty to run, if necessary)
alias restart-xserver='sudo systemctl restart display-manager'

# Neovim
alias f='nvim'
compdef _vim f
alias fn='nvim -u NORC --noplugin'
compdef _vim fn
alias v='nvim ~/dotfiles/dotfiles/.config/nvim/init.vim'
alias z='nvim ~/dotfiles/dotfiles/.zshrc'
alias clubhouse='nvim -c "Clubhouse"'
alias standup='nvim -c "Standup"'
alias mentor='nvim -c "Mentor"'

# Grep, but ignore annoying directories
alias grep='grep --color=auto'

# enable color support of ls and also add handy aliases
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

alias sl='ls'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Common shortcuts for source file and virtualenv
alias gcr='google-chrome'
alias fz='nvim ~/.zshrc'
alias c='cat'
alias sr='source'
alias va='source venv/bin/activate'
alias va.='source .venv/bin/activate'
alias fnv='nvim ~/.config/nvim/init.vim'
alias falac='nvim ~/.config/alacritty/alacritty.yml'
#alias dav='deactivate'

# diff
# r: recursively; u: shows line number; p: shows difference in C function
# P: if multiple files then showing complete path
alias diff='diff -rupP'

# Set copy/paste helper functions
# the perl step removes the final newline from the output
alias pbcopy="perl -pe 'chomp if eof' | xsel --clipboard --input"
alias pbpaste='xsel --clipboard --output'

# Octave
alias octave='octave --no-gui'

# Public IP
alias publicip='curl -s checkip.amazonaws.com'

# Git
# NOTE: git add --patch forces interactive consideration of all hunks; useful
alias g='git'
alias gi='git init'
alias gst='git status'
alias gg='nvim -c "G | only"'
alias gl='git --no-pager branch --verbose --all'
alias gm='git commit --verbose'
alias gam='git add --all && git commit --verbose'
alias gp='git remote prune origin && git remote set-head origin -a'
alias gdw='git diff --word-diff'
alias gco='git checkout'
alias gcm='git commit -m'
alias glg='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
alias glga='git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short --all'
alias gad='git add'
alias gt='git tag'
alias grm='git rm --cached'
alias gcl='git clone'
alias gbc='git branch'
alias gremote='git remote add origin'
alias grt='git revert'

# battery
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E "state|time\ to\ full|percentage"'

# dynamodb
alias docker-dynamodb="docker run -v /data:$HOME/data -p 8000:8000 dwmkerr/dynamodb -dbPath $HOME/data"

# alias for say
alias say='spd-say'
compdef _dict_words say

# reload zshrc
alias so='source ~/.zshrc'

# Cookiecutter (project boilerplate generator)
alias cookiecutter-hovercraft='cookiecutter gh:pappasam/cookiecutter-hovercraft'

# Rust

# need cargo install cargo-update
# NOTE: CARGO_INCREMENTAL=0 turns off incremental compilation
alias cargo-update='cargo +nightly install-update -a'
alias cargo-doc='cargo doc --open'

# Python
# Enable things like "pip install 'requests[security]'"
alias pip='noglob pip'
alias poetry-clean='poetry cache:clear --all pypi'
alias py='nvim -c "silent! normal! ggdG" -c "ReplToggle" /tmp/repl.py'
alias pycache-clean='find . -name "*.pyc" -delete'

# Poetry
alias pr='poetry run'

# }}}
# General: functions {{{

# Tmux Launch
# NOTE: I use the option "-2" to force Tmux to accept 256 colors. This is
# necessary for proper Vim support in the Linux Console. My Vim colorscheme,
# PaperColor, does a lot of smart translation for Color values between 256 and
# terminal 16 color support, and this translation is lost otherwise.
# Steps (assuming index of 1, which requires tmux config):
# 1. Create session in detached mode
# 2. Select first window
# 3. Rename first window to 'edit'
# 4. Attach to session newly-created session
function t() {
  if [ -n "$TMUX" ]; then
    echo 'Cannot run t() in tmux session' | boxes | lolcat
    return 1
  elif [[ $# > 0 ]]; then
    SESSION=$1
  else
    SESSION=Main
  fi
  if tmux has-session -t $SESSION 2>/dev/null; then
    echo "session '$SESSION' already exists, attach with: tmux -2 attach -t $SESSION" | boxes | lolcat
  else
    tmux -2 new-session -d -s $SESSION
    #if [[ "$(alacritty-which-colorscheme)" = 'light' ]]; then
    #  tmux -2 select-window -t $SESSION:1
    #  tmux source-file ~/.tmux-light
    #fi
    tmux -2 attach -t $SESSION
  fi
}

function tmux-colors() {
  # output colors for tmux
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
  done
}

# Go to a Neovim plugin
function vplug() {
  cd ~/.config/nvim/pack/packager/start/$1
}
_vplug_completion() {
  _directories -W "$HOME/.config/nvim/pack/packager/start"
}
compdef _vplug_completion vplug

# cd to the current git root
function gr() {
  if [ $(git rev-parse --is-inside-work-tree 2>/dev/null ) ]; then
    cd $(git rev-parse --show-toplevel)
  else
    echo "'$PWD' is not inside a git repository"
    return 1
  fi
}

# git diff
function gd() {
  if [[ "$(alacritty-which-colorscheme)" = 'light' ]]; then
    git diff $@ | delta --light --line-numbers
  else
    git diff $@ | delta --dark  --line-numbers
  fi
}

# open browser at current location
function gop() {
  if [ ! $(git rev-parse --is-inside-work-tree 2>/dev/null ) ]; then
    echo "'$PWD' is not inside a git repository"
    return 1
  fi
  local branch_current=$(git branch --show-current)
  if [[ $# = 0 ]]; then
    gh browse --branch "$branch_current"
    return 0
  fi
  local git_root=$(git root)
  local arg_expanded=$(readlink -f "$1")
  local arg_relative=$(realpath --relative-base="$git_root" "$arg_expanded")
  if [[ "$arg_relative" = '.' ]]; then
    gh browse --branch "$branch_current"
  else
    gh browse "$arg_relative" --branch "$branch_current"
  fi
}

# upgrade relevant local systems
function upgrade() {
  sudo apt update
  sudo apt upgrade -y
  sudo apt autoremove -y
  asdf update
  asdf plugin-update --all
  update_dotfiles
  cd
}

function update_dotfiles() {
  local NOW=$(date)
  # update ~/.zshrc
  # cp ~/.zshrc ~/dotfiles
  # update ~/.tmux.conf
  cp ~/.tmux.conf ~/dotfiles
  # update alacritty
  cp -r ~/.config/alacritty ~/dotfiles/.config
  # update .gitconfig
  cp ~/.gitconfig ~/dotfiles
  # update config files for nvim
  cp -r ~/.config/nvim/doc ~/dotfiles/.config/nvim
  cp ~/.config/nvim/init.vim ~/dotfiles/.config/nvim
  cp ~/.config/nvim/coc-settings.json ~/dotfiles/.config/nvim
  # push git repo of dotfiles
  cd ~/dotfiles
  git add .
  git commit -m "$NOW"
  git push
}

# Alacritty Helpers
function dark() {
  alacritty-colorscheme \
    -c "$HOME/.config/alacritty/alacritty.yml" \
    apply 'ayu_dark.yaml'
  if [ ! -z "$TMUX" ]; then
    tmux source-file ~/.tmux.conf
  fi
}

function light() {
  alacritty-colorscheme \
    -c "$HOME/.config/alacritty/alacritty.yml" \
    apply 'pencil_light.yaml'
  if [ ! -z "$TMUX" ]; then
    tmux source-file ~/.tmux-light
  fi
}

function alacritty-install() {
  cargo build --release

  # Install
  sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database

  # terminfo
  tic -xe alacritty,alacritty-direct extra/alacritty.info

  # man page
  sudo mkdir -p /usr/local/share/man/man1
  gzip -c extra/alacritty.man | \
    sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null
}

# Fix window dimensions: tty mode
# Set consolefonts to appropriate size based on monitor resolution
# For each new monitor, you'll need to do this manually
# Console fonts found here: /usr/share/consolefonts
# Finally, suppress all messages from the kernel (and its drivers) except panic
# messages from appearing on the console.
function fix-console-window() {
  echo "Getting window dimensions, waiting 5 seconds..."
  MONITOR_RESOLUTIONS=$(sleep 5 && xrandr -d :0 | grep '*')
  if $(echo $MONITOR_RESOLUTIONS | grep -q "3840x2160"); then
    setfont Uni3-Terminus32x16.psf.gz
  elif $(echo $MONITOR_RESOLUTIONS | grep -q "2560x1440"); then
    setfont Uni3-Terminus24x12.psf.gz
  fi
  echo "Enter sudo password to disable kernel from sending console messages..."
  sudo dmesg -n 1
}

function gitzip() {  # arg1: the git repository
  if [ $# -eq 0 ]; then
    local git_dir='.'
  else
    local git_dir="$1"
  fi
  pushd $git_dir > /dev/null
  local git_root=$(git rev-parse --show-toplevel)
  local git_name=$(basename $git_root)
  local outfile="$git_root/../$git_name.zip"
  git archive --format=zip --prefix="$git_name-from-zip/" HEAD -o "$outfile"
  popd > /dev/null
}
compdef _directories gitzip

# Pipe man stuff to neovim
function m() {
  man --location "$@" &> /dev/null
  if [ $? -eq 0 ]; then
    man --pager=cat "$@" 2>/dev/null | nvim -c '+Man!' -
  else
    man "$@"
  fi
}
compdef _man m

# dictionary lookups
function def() {  # arg1: word
  dict -d gcide $1
}
compdef _dict_words def

function syn() {  # arg1: word
  dict -d moby-thesaurus $1
}
compdef _dict_words syn

# I type cd so much, I'll just type d instead
function d() { #arg1: directory
  cd $1
}
compdef _directories d

# Move up n directories using:  cd.. dir
function cd_up() {  # arg1: number|word
  pushd . >/dev/null
  cd $( pwd | sed -r "s|(.*/$1[^/]*/).*|\1|" ) # cd up into path (if found)
}

# Open files with gnome-open
function gn() {  # arg1: filename
  gio open $1
}

# Open documentation files
export DOC_DIR="$HOME/Documents/reference"
function doc() {  # arg1: filename
  gio open "$DOC_DIR/$1"
}
compdef "_files -W $DOC_DIR" doc

# Cargo local documentation for crates
function cargodoc() {  # arg1: packagename
  if [ $# -eq 0 ]; then
    cargo doc --open
  elif [ $# -eq 1 ]; then
    cargo doc --open --package $1
  else
    echo 'usage: cargodoc [<package name>]'
    return 1
  fi
}

function global-install() {
  rustglobal-install
  nodeglobal-install
  pyglobal-install
  awscliglobal-install
  goglobal-install
}

function rustglobal-install() {
  rustup component add rls
  rustup component add rust-src
  cargo install bat
  cargo install cargo-deb
  cargo install cargo-edit
  cargo install cargo-update
  cargo install fd-find
  cargo install git-delta
  cargo install ripgrep
  asdf reshim rust
  cargo install-update -a
}

function nodeglobal-install() {
  local env=(
    @angular/cli
    bash-language-server
    devspace
    dockerfile-language-server-nodejs
    git+https://github.com/Perlence/tstags.git
    jsctags
    neovim
    nginx-linter
    nginxbeautifier
    npm
    prettier
    tree-sitter-cli
    write-good
  )
  npm install --no-save -g $env
  asdf reshim nodejs
}

function pydev-install() {  ## Install default python dependencies
  local for_pip=(
    bpython
    mypy
    neovim-remote
    pip
    pylint
    pynvim
    wheel
  )
  pip install -U $for_pip
  asdf reshim python
}

function pipx-upgrade() {
  pipx uninstall $1
  pipx install $1
}

function pyglobal-install() {  ## Install global Python applications
  pip install -U pipx
  pydev-install
  asdf reshim python
  local for_pipx=(
    alacritty-colorscheme
    aws-sam-cli
    black
    cookiecutter
    docformatter
    docker-compose
    isort
    jupyterlab
    jupytext
    nginx-language-server
    pre-commit
    restview
    toml-sort
    ueberzug
  )
  if command -v pipx > /dev/null; then
    for arg in $for_pipx; do
      pipx uninstall "$arg" && pipx install "$arg"
    done
  else
    echo 'pipx not installed. Install with "pip install pipx"'
  fi
}

function awscliglobal-install() {  ## Install latest version of aws cli (v2)
  pushd
  cd "$HOME/Downloads"
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install --install-dir "$HOME/.local/aws-cli" --bin-dir "$HOME/bin" --update
  rm -r aws
  curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
  sudo dpkg -i session-manager-plugin.deb
  rm session-manager-plugin.deb
  popd
}

function goglobal-install() {  ## Install default golang dependencies
  go get github.com/mattn/efm-langserver
  asdf reshim golang
}

function _asdf_complete_plugins() {  ## zsh completion function for plugin-list
  local -a subcmds
  subcmds=($(asdf plugin-list | tr '\n' ' '))
  _describe 'List installed plugins for zsh completion' subcmds
}

function asdfl() {  ## Install and set the latest version of asdf
  asdf install $1 latest && asdf global $1 latest
}
compdef _asdf_complete_plugins asdfl

## activate virtual environment from any directory from current and up
## Name of virtualenv
#VIRTUAL_ENV_DEFAULT=venv
#function va() {  # No arguments
#  local venv_name="$VIRTUAL_ENV_DEFAULT"
#  local old_venv=$VIRTUAL_ENV
#  local slashes=${PWD//[^\/]/}
#  local current_directory="$PWD"
#  for (( n=${#slashes}; n>0; --n ))
#  do
#    if [ -d "$current_directory/$venv_name" ]; then
#      source "$current_directory/$venv_name/bin/activate"
#      if [[ "$old_venv" != "$VIRTUAL_ENV" ]]; then
#        echo "Activated $(python --version) virtualenv in $VIRTUAL_ENV"
#      fi
#      return
#    fi
#    local current_directory="$current_directory/.."
#  done
#  # If reached this step, no virtual environment found from here to root
#  if [[ -z $VIRTUAL_ENV ]]; then
#  els
#    deactivate
#    echo "Disabled existing virtualenv $old_venv"
#  fi
#}

# Automatically find virtual environment for you
# Once one found, gives the prompt
VIRTUAL_ENV_DEFAULT=venv
DOT_VIRTUAL_ENV=.venv
function venv_lookup() {  # No arguments
  local venv_name="$VIRTUAL_ENV_DEFAULT"
  local dot_venv="$DOT_VIRTUAL_ENV"
  local slashes=${PWD//[^\/]/}
  local current_directory="$PWD"
  for (( n=${#slashes}; n>0; --n ))
  do
    if [ -d "$current_directory/$venv_name" ]; then
      echo -e "A virtualenv found, enter 'va' to activate" | boxes | lolcat
      return
   elif [ -d "$current_directory/$dot_venv" ]; then
      echo -e "A virtualenv found, enter 'va.' to activate" | boxes | lolcat
      return
    fi
  done
}

# Function to help you deactivate the virtual environment
# Also provides the name and path of the deactivated venv
function dva() {
  local old_venv=$VIRTUAL_ENV
  deactivate
  echo "Disabled virtualenv $old_venv" | boxes | lolcat
}

# Create and activate a virtual environment with all Python dependencies
# installed. Optionally change Python interpreter.
function ve() {  # Optional arg: python interpreter name
  local venv_name="$VIRTUAL_ENV_DEFAULT"
  local dot_venv="$DOT_VIRTUAL_ENV"
  if [ -z "$1" ]; then
    local python_name='python'
  else
    local python_name="$1"
  fi
  if [ ! -d "$venv_name" -a ! -d "$dot_venv" ]; then
    $python_name -m venv "$venv_name"
    if [ $? -ne 0 ]; then
      local error_code=$?
      echo "Virtualenv creation failed, aborting" | boxes | lolcat
      return error_code
    fi
    source "$venv_name/bin/activate"
    pip install -U pip
    pydev-install  # install dependencies for editing
    deactivate
  else
    venv_lookup
  fi
}
compdef _command ve

# Choose a virtualenv from backed up virtualenvs
# Assumes in current directory, set up with zsh auto completion based on
# current directory.
function vc() {  # Optional arg: python venv version
  if [ -z "$VIRTUAL_ENV" ]; then
    echo "No virtualenv active, skipping backup"
  else
    mkdir -p venv.bak
    local python_version=$(python3 --version | cut -d ' ' -f 2)
    local bak_dir="venv.bak/$python_version"
    if [ ! -d "$bak_dir" ]; then
      mv "$VIRTUAL_ENV" "$bak_dir"
    else
      echo "ERROR: $bak_dir already exists"
      return 1
    fi
  fi
  if [ -z "$1" ]; then
    return 0
  fi
  local choose_dir="venv.bak/$1"
  if [ ! -d "$choose_dir" ]; then
    echo "ERROR: no such virtualenv $1 backed up"
    return 1
  fi
  mv "$choose_dir" .venv
}
_vc_completion() {
  _directories -W $PWD/venv.bak
}
compdef _vc_completion vc

# Print out the Github-recommended gitignore
export GITIGNORE_DIR=$HOME/src/lib/gitignore
function gitignore() {
  if [ ! -d "$GITIGNORE_DIR" ]; then
    mkdir -p $HOME/src/lib
    git clone https://github.com/github/gitignore $GITIGNORE_DIR
    return 1
  elif [ $# -eq 0 ]; then
    echo "Usage: gitignore <file1> <file2> <file3> <file...n>"
    return 1
  else
    # print all the files
    local count=0
    for filevalue in "$@"; do
      echo "#################################################################"
      echo "# $filevalue"
      echo "#################################################################"
      cat $GITIGNORE_DIR/$filevalue
      if [ $count -ne $# ]; then
        echo
      fi
      (( count++ ))
    done
  fi
}
compdef "_files -W $GITIGNORE_DIR/" gitignore

# Create instance folder with only .gitignore ignored
function mkinstance() {
  mkdir instance
  cat > instance/.gitignore <<EOL
*
!.gitignore
EOL
}

# Initialize Python Repo
function poetry-init() {
  if [ -f pyproject.toml ]; then
    echo "pyproject.toml exists, aborting"
    return 1
  fi
  poetry init --no-interaction &> /dev/null
  cat-pyproject >> pyproject.toml
  toml-sort --in-place pyproject.toml
  touch README.md
}

# Create New Python Repo
function pynew() {
  if [ $# -ne 1 ]; then
    echo "pynew <directory>"
    return 1
  fi
  local dir_name="$1"
  if [ -d "$dir_name" ]; then
    echo "$dir_name already exists"
    return 1
  fi
  mkdir "$dir_name"
  cd "$dir_name"
  poetry-init
  gitignore Python.gitignore | grep -v instance/ > .gitignore
  mkinstance
  ve
  cat > main.py <<EOL
"""The main module"""

EOL
}

# Profiling neovim
function nvim-profiler() {
  nvim --startuptime nvim_startup.txt \
    --cmd 'profile start nvim_init_profile.txt' \
    --cmd 'profile! file ~/.config/nvim/init.vim' \
    "$@"
}

# GIT: git-clone keplergrp repos to src/ directory
function klone() {
  git clone git@github.com:KeplerGroup/$1
}

# GIT: push current branch from origin to current branch
function push() {
  local current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git push -u origin "$current_branch"
}

# GIT: pull current branch from origin to current branch
function pull() {
  local current_branch="$(git rev-parse --abbrev-ref HEAD)"
  git pull origin "$current_branch"
}

# GITHUB: list all of an organization's Repositories
function github-list {
  local username=$1
  local organization=$2
  local page=$3
  curl -u $username "https://api.github.com/orgs/$organization/repos?per_page=100&page=$page"
}

# Timer
function countdown-seconds(){
  local date1=$((`date +%s` + $1));
  while [ "$date1" -ge `date +%s` ]; do
    ## Is this more than 24h away?
    local days=$(($(($(( $date1 - $(date +%s))) * 1 ))/86400))
    echo -ne "$days day(s) and $(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
    sleep 0.1
  done
  echo ""
  spd-say "Beep, beep, beeeeeeeep. Countdown is finished"
}

function countdown-minutes() {
  countdown-seconds $(($1 * 60))
}

function stopwatch(){
  local date1=`date +%s`;
  while true; do
    local days=$(( $(($(date +%s) - date1)) / 86400 ))
    echo -ne "$days day(s) and $(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
    sleep 0.1
  done
}

function start() {
  local cowsay_quote="$(fortune -s | grep -v '\-\-' | grep .)"
  figlet -f ~/.local/share/fonts/3d.flf "Columbia" | lolcat
  echo -e
  echo -e "How's the weather today in New York?" | boxes -d simple | lolcat
  curl -s "wttr.in/new+york?1FnTQ" | lolcat
  echo -e
  echo -e "$cowsay_quote" | cowsay -b | lolcat
}

function deshake-video() {
  # see below link for documentation
  # https://github.com/georgmartius/vid.stab
  if [ $# -ne 2 ]; then
    echo "deshake-video <infile> <outfile>"
    exit 1
  fi
  local infile="$1"
  local outfile="$2"
  local transfile="$infile.trf"
  if [ ! -f "$transfile" ]; then
    echo "Generating $transfile ..."
    ffmpeg2 -i "$infile" -vf vidstabdetect=result="$transfile" -f null -
  fi
  ffmpeg2 -i "$infile" -vf \
    vidstabtransform=smoothing=10:input="$transfile" \
    "$outfile"
}

function dat(){
  if [ $# -ne 1 ]; then
    echo "dat <file_name>"
    return 1
  fi
  local file_name="$1"
  strfile -c % "$file_name" "$file_name.dat"
}

# Lint Jenkinsfile
function jenkinsfilelint() {  # [arg1]: path to Jenkinsfile
  if [ $# -eq 0 ]; then
    local jenkinsfile_path='Jenkinsfile'
  elif [ $# -eq 1 ]; then
    local jenkinsfile_path=$1
  else
    echo 'lint-jenkinsfile [<path-to-jenkinsfile>|default is Jenkinsfile]'
    return 1
  fi
  local result=$(curl -s -X POST -F "jenkinsfile=<$jenkinsfile_path" \
    localhost:8080/pipeline-model-converter/validate )
  if [[ $result == 'Jenkinsfile successfully validated.' ]]; then
    echo $result
    return 0
  else
    echo "error processing Jenkinsfile at '$jenkinsfile_path'"
    if [[ $result != '' ]]; then
      echo 'error message:'
      echo $result
    fi
    return 1
  fi
}

# Zoom
function zoomy() {
  if [ -z $1 ]; then
    echo "Conference room number needed! 'zoomy 1234567890'"
  else
    gio open "zoommtg://zoom.us/join?action=join&confno=$1"
  fi
}

# Yaml to JSON
function yamltojson() {
  local pycmd='import sys, yaml, json'
  local pycmd="$pycmd;json.dump(yaml.load(sys.stdin), sys.stdout, indent=2)"
  cat $1 | python -W ignore -c "$pycmd"
}
compdef '_files -g "*.(yml|yaml)"' yamltojson

# }}}
# General: cat functions {{{

function cat-pyproject() {
  cat "$HOME/dotfiles/cat-scripts/pyproject-top.toml"
}

# }}}
# General: executed commands {{{

if [[ -o interactive ]]; then
  if [[ "$TMUX_PANE" == "%0" ]]; then
    # if you're in the first tmux pane within all of tmux
   start
  elif [ -n "$TMUX" ]; then
    # do nothing
  elif tmux has-session -t Main 2>/dev/null; then
    # do nothing
  else
    echo 'A good day starts from using tmux! Enter "t" now!' | cowsay | lolcat
  fi

  # turn off ctrl-s and ctrl-q from freezing / unfreezing terminal
  stty -ixon

  # kubectl autocompletion
  # NOTE: commented out currently because this slows zsh load down a lot
  # if [ $commands[kubectl] ]; then
  #   source <(kubectl completion zsh)
  # fi

  # direnv
  if [ $commands[direnv] ]; then
    eval "$(direnv hook zsh)"
  fi

  # Try activate virtual environment, don't worry about console output
  # va &> /dev/null
fi

# }}}
# Tidbits: helpful hints {{{

# Searching for a specific man page
#   1. apropros
#   2. man -k
#
# Clearning "less" search results
#   Alt-u

# }}}

export PATH="$HOME/.poetry/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
