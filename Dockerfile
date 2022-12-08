FROM alpine:latest

LABEL maintainer="Terje Kvernes <terje@kvernes.no>"

ARG HOME=/var/lib/bastion

ARG USER=bastion
ARG GROUP=bastion
ARG UID=4096
ARG GID=4096

ENV HOST_KEYS_PATH_PREFIX="/usr"
ENV HOST_KEYS_PATH="${HOST_KEYS_PATH_PREFIX}/etc/ssh"

COPY bastion /usr/sbin/bastion

RUN addgroup -S -g ${GID} ${GROUP} \
    && adduser -D -h ${HOME} -s /bin/ash -g "${USER} service" \
           -u ${UID} -G ${GROUP} ${USER} \
    && sed -i "s/${USER}:!/${USER}:*/g" /etc/shadow \
    && set -x \
    && apk add --no-cache openssh-server openssh-client python3 \
    && echo "Welcome to Bastion!" > /etc/motd \
    && chmod +x /usr/sbin/bastion \
    && mkdir -p ${HOST_KEYS_PATH} \
    && mkdir /etc/ssh/auth_principals \
    && echo "bastion" > /etc/ssh/auth_principals/bastion

EXPOSE 22/tcp

LABEL org.opencontainers.image.source=https://github.com/terjekv/docker-bastion
LABEL org.opencontainers.image.description="A bastion server with python3 for sshuttle support."
LABEL org.opencontainers.image.licenses=MIT

VOLUME ${HOST_KEYS_PATH}

ENTRYPOINT ["bastion"]
