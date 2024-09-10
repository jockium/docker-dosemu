FROM jockium/docker-supervisor
# VNC doesn't start without xfonts-base
RUN apt-get update && \
    apt-get -y -u dist-upgrade && \
    apt-get -y --no-install-recommends install wget tightvncserver xfonts-base \
            lwm xterm vim-tiny less ca-certificates balance \
            zip unzip pwgen xdotool telnet nano procps \
            mtools dosfstools dos2unix inetutils-telnetd openbsd-inetd \
            tigervnc-viewer tcpser ser2net socat liblockfile-bin libasound2 libgpm2 libsdl1.2debian  libslang2 libsndfile1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#dosemu no longer in contrib
ADD http://archive.debian.org/debian-archive/debian/pool/contrib/d/dosemu/dosemu_1.4.0.7+20130105+b028d3f-2+b1_amd64.deb /tmp
RUN dpkg -i /tmp/dosemu_1.4.0.7+20130105+b028d3f-2+b1_amd64.deb 

COPY scripts/ /usr/local/bin/
COPY supervisor/ /etc/supervisor/conf.d/
COPY setup/ /tmp/setup/
COPY autoexec.bat /etc/dosemu/freedos/autoexec.bat
RUN /tmp/setup/setup.sh && rm -r /tmp/setup

EXPOSE 5901
CMD ["/usr/local/bin/boot-supervisord"]

