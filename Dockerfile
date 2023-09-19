ARG docker_version=20.10
FROM docker:${docker_version}-dind

RUN set -x \
    && apk add --no-cache --update \
        bash \
        curl \
        docker-compose \
        git \
        jq \
        make

ARG docker_compose_plugin_version=2.2.3
ENV DOCKER_COMPOSE_PLUGIN_VERSION=${docker_compose_plugin_version}
RUN set -x \
    && mkdir -p ~/.docker/cli-plugins/ \
    && curl -sSL "https://github.com/docker/compose-cli/releases/download/v${DOCKER_COMPOSE_PLUGIN_VERSION}/docker-compose-linux-amd64" -o ~/.docker/cli-plugins/docker-compose \
    && chmod +x ~/.docker/cli-plugins/docker-compose

COPY concourse-dind-entrypoint.sh /usr/local/bin/
COPY docker-utils.sh /opt/

ENTRYPOINT ["concourse-dind-entrypoint.sh"]
CMD []
