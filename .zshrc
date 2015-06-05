# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Allow updates to be installed automatically if this is true
DISABLE_UPDATE_PROMPT=true

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(osx git git-flow python)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin:$PATH:/usr/local/globus-5.2.5/bin
#export PATH=/Users/dan/pear/bin:$PATH
export MANPATH=$MANPATH:/opt/local/share/man

export CC=/usr/bin/gcc

# ^^^^^^^^^^^
# Oh my zsh config

setopt promptsubst
autoload -U promptinit
promptinit
prompt grb

PATH=$PATH:/usr/local/pgsql/bin
PATH=$PATH:~/bin
PATH=/usr/local/sbin:/usr/local/bin:$PATH
PATH=$PATH:~/Library/Haskell/bin

#export TERM='xterm-color'
alias ls='ls -G'
alias ll='ls -lG'
alias duh='du -csh'
export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
export GREP_OPTIONS="--color"
export EDITOR=vim

# Go Lang Var
export GOPATH=/Users/dan/projects/go_chat/

# MYSQL Database Vars
export MYSQL_USERNAME='root'
export MYSQL_PASSWORD='dell8100'

# Increase history length
export HISTSIZE=100000

# SSH Aliases
alias sshdan="ssh dan@romaimperator.no-ip.org -p 10022 -C"
alias sshdantun="ssh dan@romaimperator.no-ip.org -p 10022 -D 9000 -C"
alias sshdepta="ssh deploy@trustauth.com -C"
alias sshrootta="ssh root@trustauth.com -C"
alias sshhackta="ssh root@hack.trustauth.com -C"
alias sshcluster3="ssh user@cluster-3.local -C"

# Rsync Aliases
alias podsync="rsync -av --progress ~/Music/iTunes/iTunes\\ Media/Podcasts storage@192.168.1.121::podcasts"

# CD Aliases
alias cdtaf="cd ~/Dropbox/TrustAuth/trustauth-firefox/"
alias cdtaw="cd ~/Dropbox/TrustAuth/trustauth-wordpress-svn/"
alias cdtac="cd ~/Dropbox/TrustAuth/trustauth-chrome/"
alias cdasi="cd ~/projects/asi"
alias cdbbt="cd ~/projects/bbt"

# Mkdir Aliases
alias mkdirp="mkdir -p"

# Unison Aliases
alias neonsync="unison "

# Rails Related Aliases
alias r='rails'
alias g='generate'

# .zshrc
alias tmux="TERM=screen-256color-bce tmux"

# Make C-s and C-q useable
stty -ixon -ixoff

# Load up ssh-agent with mah ssh keys
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add
fi

# Initialize rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

