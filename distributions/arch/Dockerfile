FROM archlinux:latest

WORKDIR /root

# HACK to auto-accept. `--noconfirm` did not work
RUN yes | pacman -Syu
RUN yes | pacman -Sy htop tmux vim neofetch
RUN yes | pacman -Sy python

RUN echo "source ~/.bash_aliases" >> /root/.bashrc

CMD ["/usr/bin/bash"]
