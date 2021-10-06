FROM ubuntu:21.04
#FROM ubuntu:latest
#FROM ubuntu:hirsute
#FROM ubuntu:rolling

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y bash htop tmux neofetch vim
RUN apt-get install -y python3 python3-pip

#RUN apt-get install -y x11-apps
#RUN apt-get install -y alsa-utils

#RUN apt-get install -y mpv

WORKDIR /root

CMD ["/usr/bin/bash"]
