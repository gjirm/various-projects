FROM ubuntu
RUN apt-get update -y && apt-get install -y git curl zsh sudo locales
RUN useradd -ms /bin/bash -d /home/jirm -G sudo -u 1001 -p "$(openssl passwd -1 jirm)" jirm
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo 'Europe/Prague' > /etc/timezone
USER jirm
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
WORKDIR /home/jirm