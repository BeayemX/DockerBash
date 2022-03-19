FROM fedora:latest

RUN dnf update -y
RUN dnf install -y htop tmux neofetch vim

RUN echo "source ~/.bash_aliases" >> /root/.bashrc

WORKDIR /root

CMD ["/usr/bin/bash"]
