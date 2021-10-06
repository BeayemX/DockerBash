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

# Instructions
1. Run `db-rebuild-image` on a new system
2. Run `db` or `db-tmp` to start a new container
   1. When using optional names it is possible to run multiple docker-bashes i.e. 
      1. `db ubuntu-test`
      2. `db bash-test`


## Add new distribution
+ Add new folder to `distributions`
+ Add `Dockerimage`
+ docker-bash commands will detect new distro automatically


# Information
The file `bash_aliases.sh` can be used to change aliases at runtime.


# X11
## On Host
```sh
xhost +
```

## Inside Container
```sh
--env="DISPLAY"
--volume="$HOME/.Xauthority:$HOME/.Xauthority"'  # probably not needed, because $HOME would not map correctly in docker anyway?

# Not sure if needed
--volume /tmp/.X11-unix:/tmp/.X11-unix
```
