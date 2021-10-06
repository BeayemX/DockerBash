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
alias find-package='_find'
alias update='_update'
alias install='_install'

function _update()
{
	if hash apt 2>/dev/null; then
		apt update && apt upgrade;
	elif hash dnf 2>/dev/null; then
		dnf update;
	elif hash pacman 2>/dev/null; then
		pacman -Syu;
	elif hash apk 2>/dev/null; then
		apk update;
	else
		echo PackageManager not detected.
	fi
}

function _install()
{
	if hash apt 2>/dev/null; then
		apt install $@;
	elif hash dnf 2>/dev/null; then
		dnf install $@;
	elif hash pacman 2>/dev/null; then
		pacman -Sy $@;
	elif hash apk 2>/dev/null; then
		apk add $@;
	else
		echo PackageManager not detected.
	fi
}

function _find()
{
	if hash apt-cache 2>/dev/null; then
		apt search $@;
		# apt list $@;
	elif hash dnf 2>/dev/null; then
		dnf search $@;
		# dnf list $@;
	elif hash pacman 2>/dev/null; then
		pacman -Ss $@;
	elif hash apk 2>/dev/null; then
		apk search "$@";
		# apk search -v -d "$@"; # Also search description
	else
		echo PackageManager not detected.
	fi
}

# Execute for every new bash
echo
neofetch
