FROM alpine:latest

WORKDIR /root

RUN apk update
RUN apk add bash htop tmux vim neofetch python3

RUN echo "source ~/.bash_aliases" >> /root/.bashrc

CMD ["/bin/bash"]
