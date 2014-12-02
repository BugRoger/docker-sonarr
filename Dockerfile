FROM debian:jessie
MAINTAINER tuxeh <sirtuxeh@gmail.com>

# use sonarr master branch, user can change branch and update within sonarr
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC \
  && echo "deb http://apt.sonarr.tv/ master main" | tee -a /etc/apt/sources.list \
  && apt-get update -q \
  && apt-get install -qy nzbdrone \
  ; apt-get clean \
  ; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN chown -R nobody:users /opt/NzbDrone \
  ; mkdir -p /volumes/config/sonarr /volumes/completed /volumes/media \
  && chown -R nobody:users /volumes

EXPOSE 8989
VOLUME /volumes/config
VOLUME /volumes/completed
VOLUME /volumes/media

ADD develop/start.sh /
RUN chmod +x /start.sh

ADD develop/sonarr-update.sh /sonarr-update.sh
RUN chmod 755 /sonarr-update.sh \
  && chown nobody:users /sonarr-update.sh

USER nobody
WORKDIR /opt/NzbDrone

ENTRYPOINT ["/start.sh"]
