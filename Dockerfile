ARG docker_version=27.0.3
FROM docker:${docker_version}-dind

RUN set -x \
    && apk add --no-cache --update \
        bash \
        curl \
        git \
        jq \
        make

COPY concourse-dind-entrypoint.sh /usr/local/bin/
COPY docker-utils.sh /opt/

ENTRYPOINT ["concourse-dind-entrypoint.sh"]
CMD []
