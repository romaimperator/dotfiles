source /Users/dan/.rvm/scripts/rvm
rvm use ruby-1.9.3
PATH=$PATH:/usr/local/mysql/bin/

# SSH Aliases
alias sshdan="ssh dan@romaimperator.no-ip.org -p 10022"
alias sshdantun="ssh dan@romaimperator.no-ip.org -p 10022 -D 9000"
alias sshdepta="ssh deploy@trustauth.com"
alias sshrootta="ssh root@trustauth.com"
alias sshhackta="ssh root@hack.trustauth.com"

# Rsync Aliases
alias podsync="rsync -av --progress ~/Music/iTunes/iTunes\\ Media/Podcasts storage@192.168.1.121::podcasts"

# CD Aliases
alias cdtaf="cd ~/Dropbox/TrustAuth/trustauth-firefox/"
alias cdtaw="cd ~/Dropbox/TrustAuth/trustauth-wordpress-svn/"
alias cdtac="cd ~/Dropbox/TrustAuth/trustauth-chrome/"

# Mkdir Aliases
alias mkdirp="mkdir -p"

