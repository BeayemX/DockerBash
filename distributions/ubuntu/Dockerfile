# rolling -> latest non-LTS
FROM ubuntu:rolling

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y bash htop tmux neofetch vim
RUN apt-get install -y python3 python3-pip

WORKDIR /root

CMD ["/usr/bin/bash"]
