# What is DockerBash?
+ Temporarily run a separate os 
  + Similar to using a headless VM but easier to create
+ Try out software in an encapsulated way without affecting the host
  + Just like docker was inteded, but in a more interactive way
+ Easy management of all docker-bash containers
  + Creating / Deleting with bash autocompletion
  + Temporary containers
  + Provide simple way to add other Linux distributions

# Requirements
```sh
sudo apt install docker.io
# sudo apt install docker-compose  # Not needed for docker-bash
```

**Add user to `docker` group**

```sh
sudo groupadd docker # Group probably already created when installing docker
sudo usermod -aG docker $USER
```

Reboot is required.

# Usage
1. Run `db-rebuild-image` on a new system
   1. Run `db-rebuild-image-from-scratch` to re-create an existing image
2. Run `db` or `db-tmp` to start a new container
   1. When using optional names it is possible to run multiple docker-bashes i.e. 
      1. `db ubuntu-test`
      2. `db bash-test`


You can use tab-completion to autofill existing containers for `db` and `db-rm` commands.

You can list existing containers with:
```sh
db-ls
```


## Add new distribution
+ Add new folder to `distributions`
+ Add `Dockerimage`
+ docker-bash commands will detect new distro automatically and use the folder name as the entry name


# Information
The file `bash_aliases.sh` can be used to change aliases at runtime.

Exposed ports which will also be exposed to the host to make testing of software easier.

The host file-system is available under `/host` inside of the container.


# X11
## On Host
```sh
xhost +
```

## Container
```sh
--env="DISPLAY"
--volume /tmp/.X11-unix:/tmp/.X11-unix  # Not sure if needed
```
