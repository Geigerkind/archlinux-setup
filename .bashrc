#
# ~/.bashrc
#

# Desktop Work
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    sway
fi

# Desktop Private
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty2 ]]; then
    sway
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

. /usr/share/bash-completion/bash_completion

# get current branch in git repo
function parse_git_branch() {
        BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/*\(.*\)/\1/'`
        if [ ! "${BRANCH}" == "" ]
        then
                STAT=`parse_git_dirty`
                echo "[${BRANCH}${STAT}]"
        else
                echo ""
        fi
}

# get current status of git repo
function parse_git_dirty {
        status=`git status 2>&1 | tee`
        dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
        untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
        ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
        newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
        renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
        deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
        bits=''
        if [ "${renamed}" == "0" ]; then
                bits=">${bits}"
        fi
        if [ "${ahead}" == "0" ]; then
                bits="*${bits}"
        fi
        if [ "${newfile}" == "0" ]; then
                bits="+${bits}"
        fi
        if [ "${untracked}" == "0" ]; then
                bits="?${bits}"
        fi
        if [ "${deleted}" == "0" ]; then
                bits="x${bits}"
        fi
        if [ "${dirty}" == "0" ]; then
                bits="!${bits}"
        fi
        if [ ! "${bits}" == "" ]; then
                echo " ${bits}"
        else
                echo ""
        fi
}

function ex() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)  tar xjf $1  ;;
            *.tar.gz)   tar xzf $1  ;;
            *.bz2)      bunzip2 $1  ;;
            *.rar)      unrar x $1  ;;
            *.gz)       gunzip  $1  ;;
            *.tar)      tar xf  $1  ;;
            *.tbz2)     tar xjf $1  ;;
            *.tgz)      tar xzf $1  ;;
            *.zip)      unzip   $1  ;;
            *.xz)       unxz    $1  ;;
            *.zst)      zstd -d $1  ;;
            *.Z)        7z x    $1  ;;
            *)          echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

export PS1="\t: \[\e[32m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]: \[\e[31m\]\W\[\e[m\] \[\e[35m\]\`parse_git_branch\`\[\e[m\]\\$ \n"

# Work
# Medios Digital
alias md_dc_up="sudo docker-compose up db"
alias md_dc_redo="sudo docker system prune && sudo docker volume prune && sudo docker-compose up --build db"
alias md_cd="cd ~/Work/medios-connect-2.0"
alias md_permit_testcontainer="sudo chmod 770 /var/run/docker.sock"

# Docker
alias dcRebuildF="docker system prune && docker volume prune && docker-compose up --build"

# Util
alias ls='exa'
alias ll='ls -l'
alias df='df -h'
alias del='yay -Rs'
alias clean='yay -Scc'
alias update='yay -Syu'
alias lk='sudo loadkeys de-latin1'
alias mnt='sudo mount'
alias umnt='sudo umount'
alias plz='sudo'
alias please='sudo'
alias untar='tar -xzf'

# SSH
alias sshRPLL='ssh shino@legacyplayers.com'

# Git
alias gpush='git push origin'
alias gcmt='git commit -m'
alias gcommit='git commit -m'
alias gadd='git add'
alias gstat='git status'
alias gstatus='git status'
alias gclone='git clone'
alias gpull='git pull'
alias gstash='git stash'

# System Util
alias grubRedoConfig='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias mkinitRedo='sudo mkinitcpio -p linux'

