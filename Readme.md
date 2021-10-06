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


# Audio
aplay -l  # sound ausgabe
arecord -l  # mics
speaker-test -c 2
alsamixer

sudo vi /etc/asound.conf

```
pcm.!default {
  type asym
  capture.pcm "mic"
  playback.pcm "speaker"
}
pcm.mic {
  type plug
  slave {
    pcm "hw:1,0"
  }
}
pcm.speaker {
  type plug
  slave {
    pcm "hw:1,0"
  }
}
```

'
--device /dev/snd \
--volume=/etc/asound.conf:/etc/asound.conf:ro \
--volume="$HOME/.Xauthority:/root/.Xauthority" \ # not sure
'

## Test if working
arecord --format=S16_LE --duration=5 --rate=16000 --file-type=raw out.raw
aplay --format=S16_LE --rate=16000 out.raw



# Nvidia
Sources
+ https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html
+ https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/user-guide.html

```sh
# distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
distribution=ubuntu20.04  # Can be used as substitue for Mint

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get install -y nvidia-docker2
```

## Required parameters (not sure if all parameters are required)
```sh
   ...
	--env="DISPLAY" \
	--volume="$HOME/.Xauthority:/root/.Xauthority" \ ## wird vermutlich nicht gebraucht, da das (während gpu funktioniert hat) auf $HOME (-> '/home/christian') gezeigt hat, obwohl mit root gearbeitet wurde
	--volume /tmp/.X11-unix:/tmp/.X11-unix \
	--gpus=all \
	--runtime=nvidia \
	-e NVIDIA_DRIVER_CAPABILITIES=compute,utility,display,graphics \
	-e NVIDIA_VISIBLE_DEVICES=all \
```

# Real System
## Dockerfile
### Ubuntu
RUN apt-get install -y systemd
CMD ["/usr/lib/systemd/systemd"]

### Arch
CMD ["/sbin/init"]
CMD ["/usr/sbin/init"]