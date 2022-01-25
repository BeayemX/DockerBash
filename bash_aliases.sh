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
	alias update='sudo apt update && sudo apt upgrade'
	alias install='sudo apt install'
	#alias find-package='apt list'
	#alias find-package='apt search -F "%c %p %d %V"'
	alias find-package='apt search'
	alias uninstall='sudo apt remove'
	alias autoremove='sudo apt autoremove'

elif hash dnf 2>/dev/null; then
	alias update='sudo dnf update'
	alias install='sudo dnf install'
	alias find-package='dnf search'
	#alias uninstall=''

elif hash pacman 2>/dev/null; then
	alias update='sudo pacman -Syu'
	alias install='sudo pacman -Sy'
	alias find-package='pacman -Ss'
	#alias uninstall=''
	alias cleanup-arch='sudo pacman -Sc'

elif hash apk 2>/dev/null; then
	alias update='sudo apk update'
	alias install='sudo apk add'
	alias find-package='apk search'
	#alias uninstall=''
else
	echo PackageManager not detected.
fi


# Execute for every new bash
echo
neofetch
