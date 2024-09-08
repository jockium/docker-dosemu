FROM jockium/docker-supervisor
# VNC doesn't start without xfonts-base
RUN apt-get update && \
    apt-get -y -u dist-upgrade && \
    apt-get -y --no-install-recommends install wget tightvncserver xfonts-base \
            lwm xterm vim-tiny less ca-certificates balance \
            zip unzip pwgen xdotool telnet nano \
            mtools dosfstools dos2unix inetutils-telnetd openbsd-inetd \
            tigervnc-viewer tcpser ser2net socat liblockfile-bin && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#dosemu no longer in contrib
ADD https://master.dl.sourceforge.net/project/dosemu/dosemu/1.4.0/dosemu-1.4.0-1.i386.rpm?viasf=1 /tmp
RUN dpkg -i /tmp/dosemu-1.4.0-1.i386.rpm 

COPY scripts/ /usr/local/bin/
COPY supervisor/ /etc/supervisor/conf.d/
COPY setup/ /tmp/setup/
COPY autoexec.bat /etc/dosemu/freedos/autoexec.bat
RUN /tmp/setup/setup.sh && rm -r /tmp/setup

EXPOSE 5901
CMD ["/usr/local/bin/boot-supervisord"]

