FROM ubuntu:14.04

VOLUME ["/etc/sniproxy"]
VOLUME ["/var/log/sniproxy"]

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update && \
    apt-get install -qy --force-yes supervisor software-properties-common wget

RUN add-apt-repository ppa:dlundquist/sniproxy

RUN apt-get -qq update
RUN apt-get -y install python-software-properties \
    && apt-get -y install sniproxy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ADD sniproxy.conf.sh /usr/local/bin/sniproxy.conf.sh
ADD sniproxy.conf /etc/sniproxy.conf
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN /usr/local/bin/sniproxy.conf.sh

EXPOSE 80/tcp 443/tcp

CMD ["/usr/bin/supervisord"]
