# Base image
FROM cantara/alpine-zulu-jdk8

MAINTAINER Jonas Strømsodd <jonas.stromsodd@gmail.com>

ENV XP_DISTRO_VERSION 6.11.1
ENV XP_ROOT /enonic-xp
ENV XP_HOME /enonic-xp/home
ENV XP_USER enonic-xp

RUN echo "export XP_DISTRO_VERSION=$XP_DISTRO_VERSION" >> /etc/profile \
  && echo "export XP_ROOT=$XP_ROOT" >> /etc/profile \
  && echo "export XP_HOME=$XP_HOME" >> /etc/profile \
  && echo "export XP_USER=$XP_USER" >> /etc/profile

# Install other software
RUN apk add -U wget zip

# Extracting Enonic xp, add Enonic XP user
RUN apk add -U wget zip su-exec \
  && wget -O /tmp/distro-$XP_DISTRO_VERSION.zip http://repo.enonic.com/public/com/enonic/xp/distro/$XP_DISTRO_VERSION/distro-$XP_DISTRO_VERSION.zip\
  && cd /tmp ; unzip distro-$XP_DISTRO_VERSION.zip; rm distro-$XP_DISTRO_VERSION.zip \
  && apk del wget zip \
  &&  mv /tmp/enonic-xp-$XP_DISTRO_VERSION/home /tmp/enonic-xp-$XP_DISTRO_VERSION/home.org \
  &&  mkdir -p $XP_ROOT \
  && cp -rf /tmp/enonic-xp-$XP_DISTRO_VERSION/* $XP_ROOT/. \
  &&  adduser -h $XP_ROOT -g "" -H -D $XP_USER

# Adding launcher script
ADD launcher.sh /launcher.sh
RUN chmod +x /launcher.sh

# Exposing web port, debug port and telnet port
EXPOSE 8080 5005 5555

CMD ["/launcher.sh"]
