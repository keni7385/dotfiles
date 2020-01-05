# Path to your oh-my-zsh installation.
export ZSH=/home/andrea/.config/.oh-my-zsh

ZSH_THEME="agnoster"
DISABLE_AUTO_UPDATE="true"

# oh-my-zsh plugins plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(
  git
  docker
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob
unsetopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install

# Aliases
alias ls="ls --color=auto"
alias ll="ls -l"
alias la="ls -l -a"
alias e='emacsclient -t'
alias ec='emacsclient -c'
alias vim='emacsclient -t'
alias vi='emacsclient -t'
alias magit="ec -e '(progn (magit-status) (delete-other-windows))'"
alias mu4e="ec -e '(progn (mu4e) (delete-other-windows))'"
alias dired="ec -e '(progn (dired) (delete-other-windows))'"
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

export EDITOR="emacsclient -t"
export VISUAL="emacsclient -c"
export PATH="$PATH:$(ruby -e 'print Gem.user_dir')/bin:$HOME/.local/bin:$HOME/.local/scripts"
export SUDO_ASKPASS="$HOME/.local/scripts/dmenupass"
export HUNTER_ROOT=/home/andrea/builds/_hunter_root

export DEFAULT_USER="$(whoami)"
prompt_context(){}

# smart resizing, good ratio size/quality
# https://www.smashingmagazine.com/2015/06/efficient-image-resizing-with-imagemagick/
# smartresize FILE WIDTH OUTPUT_DIR
smartresize() {
   mogrify -path $3 -filter Triangle -define filter:support=2 -thumbnail $2 -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $1
}

# added by travis gem
[ -f /home/andrea/.config/.travis/travis.sh ] && source /home/andrea/.config/.travis/travis.sh

#recursive unzipping
runzip() {
  find . -name "*.zip" | while read filename; do unzip -o -d "`dirname "$filename"`" "$filename"; done;
}

countdown(){
   date1=$((`date +%s` + $1)); 
   while [ "$date1" -ge `date +%s` ]; do 
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
}

stopwatch(){
  date1=`date +%s`; 
   while true; do 
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"; 
    sleep 0.1
   done
}
