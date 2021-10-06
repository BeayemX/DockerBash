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
```
RUN apt-get install -y systemd
CMD ["/usr/lib/systemd/systemd"]
```

### Arch
```
CMD ["/sbin/init"]
CMD ["/usr/sbin/init"]
```