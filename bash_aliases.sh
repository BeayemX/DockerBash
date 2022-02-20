if [ -f .inputrc ]; then
	bind -f .inputrc
fi

alias re='clear && source ~/.bashrc'
alias ..='cd ..'
alias vb="vim ~/.bash_aliases"

# Tmux
alias tl='tmux ls'
alias tr='tmux-resume'
alias trr='tmux attach-session'

# Python
alias python='python3'
alias p='python'

# distribution=$(. /etc/os-release;echo $ID$VERSION_ID)

function tmux-resume()
{
	tmux attach-session -t "$@" || tmux new -s "$@";
}

# Duplicate of PackageManagement.sh
if hash apt 2>/dev/null; then
	alias update='apt update && apt upgrade'
	alias install='apt install'
	#alias find-package='apt list'
	#alias find-package='apt search -F "%c %p %d %V"'
	alias find-package='apt search'
	alias uninstall='apt remove'
	alias autoremove='apt autoremove'

elif hash dnf 2>/dev/null; then
	alias update='dnf update'
	alias install='dnf install'
	alias find-package='dnf search'
	#alias uninstall=''

elif hash pacman 2>/dev/null; then
	alias update='pacman -Syu'
	alias install='pacman -Sy'
	alias find-package='pacman -Ss'
	#alias uninstall=''
	alias cleanup-arch='pacman -Sc'

elif hash apk 2>/dev/null; then
	alias update='apk update'
	alias install='apk add'
	alias find-package='apk search'
	#alias uninstall=''
else
	echo PackageManager not detected.
fi


# Execute for every new bash
echo
neofetch
PS1="[ > ] $PS1"
