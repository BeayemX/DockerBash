FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y bash htop tmux neofetch vim
RUN apt-get install -y python3 python3-pip

RUN echo source /root/.bash_aliases >> /root/.bashrc

WORKDIR /root

CMD ["/bin/bash"]
