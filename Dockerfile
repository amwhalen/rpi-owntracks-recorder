FROM resin/rpi-raspbian:wheezy
LABEL version="0.4" description="Mosquitto and OwnTracks Recorder"
MAINTAINER Damien Martin <damlobster@gmail.com>

RUN apt-get update && apt-get install -y python-software-properties
RUN apt-get install --reinstall ca-certificates
RUN 	sudo add-apt-repository "deb http://ftp.de.debian.org/debian sid main" && \
	apt-get update && \
	apt-get install -y \
           libmosquitto1 \
           libcurl3 \
           liblua5.2-0 \
           mosquitto \
           mosquitto-clients \
           supervisor \
           && \
        apt-get clean && \
	sudo add-apt-repository --remove "deb http://ftp.de.debian.org/debian sid main" && \
        rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y wget && \
	wget http://repo.owntracks.org/repo.owntracks.org.gpg.key && \
	apt-key add repo.owntracks.org.gpg.key && \
	echo "deb  http://repo.owntracks.org/debian wheezy main" > /etc/apt/sources.list.d/owntracks.list && \
	apt-get update && \
	apt-get install ot-recorder

# data volume
VOLUME /owntracks
COPY ot-recorder.default /etc/default/ot-recorder
RUN mkdir -p /var/log/supervisor && \
	mkdir -p -m 775 /owntracks/recorder/store && \
	chown -R owntracks:owntracks /owntracks
COPY launcher.sh /usr/local/sbin/launcher.sh
RUN chmod 755 /usr/local/sbin/launcher.sh
COPY mosquitto.conf mosquitto.acl /etc/mosquitto/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 1883 8883 8083
CMD ["/usr/local/sbin/launcher.sh"]
