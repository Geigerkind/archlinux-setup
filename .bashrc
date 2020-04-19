#
# ~/.bashrc
#

# Sway
alias swayMonitor="swaymsg output HDMI-A-1 pos 0 0 && swaymsg output DP-2 pos 2560 0 && swaymsg output HDMI-A-2 pos 5120 0"

# Desktop Work
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    sources /home/shino/.config/archlinux-sway-setup/environment
    sway --my-next-gpu-wont-be-nvidia
    swayMonitor
fi

# Desktop Private
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty2 ]]; then
    startx
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

function mntSambaLocal {
    sudo mkdir /mnt/samba
    read -s -p "Password: " PASSWORD
    sudo mount -t cifs -o username=tom,password=${PASSWORD},uid=shino //192.168.178.200/nas /mnt/samba
}

function mntSambaExtern {
    sudo mkdir /mnt/samba
    read -s -p "Password: " PASSWORD
    sudo mount -t cifs -o username=tom,password=${PASSWORD},uid=shino //nas0.ddnss.de/nas /mnt/samba
}

function setSUID() {
    sudo chmod u+s /usr/bin/sway
    sudo chmod u+s /usr/bin/reboot
    sudo chmod u+s /usr/bin/poweroff
    sudo chmod u+s /usr/bin/modprobe
}

export PS1="\t: \[\e[32m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]: \[\e[31m\]\W\[\e[m\] \[\e[35m\]\`parse_git_branch\`\[\e[m\]\\$ \n"


# Docker
alias dcRebuildF="sudo docker system prune -a && sudo docker volume prune && sudo docker-compose up --build"

# Util
alias ls='exa'
alias ll='ls -l'
alias df='df -h'
alias del='yay -Rs'
alias clean='yay -Scc'
alias update='yay -Syu && setSUID'
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
alias statuus='status'

# System Util
alias grubRedoConfig='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias mkinitRedo='sudo mkinitcpio -p linux'

