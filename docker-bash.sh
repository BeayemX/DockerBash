export DEFAULT_CONTAINER_NAME='docker-bash'
export DOCKERBASH_PATH="$HOME/DockerBash/"
export DOCKERBASH_ALIASES="$DOCKERBASH_PATH/bash_aliases.sh"
export DISTRO_IMAGES=(`ls ${DOCKERBASH_PATH}/distributions/`)


if hash podman 2>/dev/null; then
	export DOCKERBASH_PROGRAM='podman'
elif hash docker 2>/dev/null; then
	export DOCKERBASH_PROGRAM='docker'
else
	echo There is not containerization software installed!;
	exit 1
fi

# Autocompletion
source $DOCKERBASH_PATH/docker-bash-completion.bash

# Usage
alias db='_docker-bash-magic'
#--mount type=bind,source=~/system-backup/Scripts/DockerBash/bash_aliases.sh,target=/root/.bash_aliases \
alias db-tmp='_select_distro && CONTAINER_NAME="tmp-shell" _db_run_template --rm $IMAGE_NAME'
alias db-delete='_docker-bash-delete-container'

# Setup
# Must be executed once before being able to use db, or when updates were made to the docker file
alias db-rebuild-image-from-scratch='_rebuild_from_scratch'
alias db-rebuild-image='_select_distro && (db-cd && builtin cd distributions/$IMAGE_DISTRO && $DOCKERBASH_PROGRAM build --tag=$IMAGE_NAME . )'

# Utilities
alias db-cd='builtin cd $DOCKERBASH_PATH'
alias db-list='_db_list'
alias db-list-names-only='_docker-bash-list-container-names-only'

# Shortcuts
alias db-ls='db-list'
alias db-ls-verbose='_db_list_verbose'
alias db-ls-names='db-list-names-only'

alias db-rm='db-delete'

# Private Methods
alias _db-init='_db_run_template $IMAGE_NAME'
alias _db-start="$DOCKERBASH_PROGRAM start $CONTAINER_NAME > /dev/null 2>&1"  # Starts a not-running container
alias _db-continue="$DOCKERBASH_PROGRAM exec -it $CONTAINER_NAME bash"  # Allows connecting multiple times at the same time; Using `docker exec -it` is necessary because `docker start -i` would share the shell/inputs with _db-start!
alias _db-stop="$DOCKERBASH_PROGRAM stop $CONTAINER_NAME > /dev/null 2>&1"

# Creates a non-existing container
function _select_distro() {
	if [[ -v DISTRO_SELECTED ]]; then
		return 0;
	fi

	PS3='Which image do you want to use? '
	select value in "${DISTRO_IMAGES[@]}"
	do
		if [[ " ${DISTRO_IMAGES[@]} " =~ " ${value} " ]]; then
			export IMAGE_DISTRO="$value";
			export IMAGE_NAME="$DEFAULT_CONTAINER_NAME-$value";
			echo Using $value;
			break;
		fi
		echo "Option '$REPLY' does not exist.";
	done
}

function _db_run_template() {
	#echo _db_run_template
	#echo $CONTAINER_NAME
	#echo $IMAGE_NAME

	# Use this variable to create the command step by step
	local cmd="$DOCKERBASH_PROGRAM run -it --hostname=$CONTAINER_NAME --name=$CONTAINER_NAME --net=host "

	cmd="$cmd --volume=$HOME:/host"
	cmd="$cmd --volume=$DOCKERBASH_ALIASES:/root/.bash_aliases"

	# Use certain dot-files from the host sytem
	if [ -f $HOME/.inputrc ]; then
		cmd="$cmd --volume=$HOME/.inputrc:/root/.inputrc"
	fi

	if [ -f $HOME/.tmux.conf ]; then
		cmd="$cmd --volume=$HOME/.tmux.conf:/root/.tmux.conf"
	fi

	if [ -f $HOME/.vimrc ]; then
		cmd="$cmd --volume=$HOME/.vimrc:/root/.vimrc"
	fi

	# Enable support for UI applicaitons
	cmd="$cmd --env DISPLAY"
	cmd="$cmd --volume=/tmp/.X11-unix:/tmp/.X11-unix"


	# Add all arguments to the command
	cmd="$cmd $@"

	${cmd};  # Execute the command
}

function _docker-bash-magic() {

    export CONTAINER_NAME=${1:-$DEFAULT_CONTAINER_NAME}
	echo "Using docker-bash '$CONTAINER_NAME'";
	#echo
	#echo "**Instructions**"
	#echo "To use x11 apps you have to execute 'xhost +' on the host";
	#echo
	#echo

	mkdir "/tmp/DockerBash/$CONTAINER_NAME" -p

	$DOCKERBASH_PROGRAM inspect -f "{{.State.Running}}" $CONTAINER_NAME > /dev/null 2>&1;

	if [ $? -eq 1 ]; then
		echo "Initializing docker container for the first time.";
		_select_distro;
		_db-init;
	else
		running=`$DOCKERBASH_PROGRAM inspect -f "{{.State.Running}}" $CONTAINER_NAME`;

		if [ "$running" != "true" ]; then
			# echo "Starting container.";
			_db-start;
		fi

		_db-continue;
	fi
}

function _docker-bash-delete-container() {
	if [ $# -eq 1 ]; then
		export CONTAINER_NAME=$1
	else
		export CONTAINER_NAME=$DEFAULT_CONTAINER_NAME
	fi

	# Ask for user confirmation
	echo
	read -r -p "Delete DockerBash container '$CONTAINER_NAME'? [Y/n] " response
	response=${response,,} # tolower

	if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then
		# Delete container
		_db-stop;
		$DOCKERBASH_PROGRAM rm $CONTAINER_NAME > /dev/null 2>&1
		echo "Docker-bash container '$CONTAINER_NAME' has been deleted."
	fi
}

function _docker-bash-list-container-names-only() {
	for IMAGE in "${DISTRO_IMAGES[@]}"
	do
		$DOCKERBASH_PROGRAM container ls --all --filter ancestor="$DEFAULT_CONTAINER_NAME-$IMAGE" | awk 'NF>1{print $NF}' | tail -n +2
	done
}

function _db_list() {
	for IMAGE in "${DISTRO_IMAGES[@]}"
	do
		local num_lines=$($DOCKERBASH_PROGRAM container ls --all --filter ancestor="$DEFAULT_CONTAINER_NAME-$IMAGE" | wc -l)
		if [ $num_lines -gt 1 ]; then
			echo "      $IMAGE      "
			#$DOCKERBASH_PROGRAM container ls --all --filter ancestor="$DEFAULT_CONTAINER_NAME-$IMAGE" | awk 'NF>1{print $NF}' | tail -n +2
			echo "`$DOCKERBASH_PROGRAM container ls --all --filter ancestor="$DEFAULT_CONTAINER_NAME-$IMAGE" | awk 'NF>1{print $NF}' | tail -n +2`"
			echo
		fi
	done
}

function _db_list_verbose() {
	echo;

	for IMAGE in "${DISTRO_IMAGES[@]}"
	do
		echo "$IMAGE";
		$DOCKERBASH_PROGRAM container ls --all --filter ancestor="$DEFAULT_CONTAINER_NAME-$IMAGE";
		echo;
	done
}

function _rebuild_from_scratch()
{
	(
		_select_distro;
		local DISTRO_SELECTED="$IMAGE_NAME";

		$DOCKERBASH_PROGRAM image rm "$IMAGE_NAME";
		db-rebuild-image;

		unset DISTRO_SELECTED;
	)
}