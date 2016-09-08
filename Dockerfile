FROM alpine:3.4

MAINTAINER Michael Kenney <mkenney@webbedlam.com>

ENV NLS_LANG American_America.AL32UTF8
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8
ENV TIMEZONE America/Denver


RUN set -x \
    && apk update \
    && apk add \
        curl \
        mysql-client \
        sudo \

##############################################################################
# users
##############################################################################

    # Create a dev user to use as the directory owner
    && addgroup dev \
    && adduser -D -s /bin/sh -G dev dev \
    && echo "dev:password" | chpasswd \

    # Setup wrapper scripts
    && curl -o /run-as-user https://raw.githubusercontent.com/mkenney/docker-scripts/master/container/run-as-user \
    && chmod 0755 /run-as-user \

##############################################################################
# ~ fin ~
##############################################################################

    && apk del \
        curl \

    && rm -rf \
        /tmp/* \
        /var/cache/apk/*

VOLUME /src
WORKDIR /src

ENTRYPOINT ["/run-as-user", "/usr/bin/mysql"]