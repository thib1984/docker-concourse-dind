# concourse-dind

Based on the official docker dind image, but using a modified version of the [concourse/docker-image-resource helper scripts](https://github.com/concourse/docker-image-resource/blob/master/assets/common.sh) to make dind working in Concourse.

# Container startup explained

* The container will check is cgroups sanitization is required (can be skipped with `SKIP_PRIVILEGED=true` ENVVAR).
* The container will start docker using the official `dockerd-entrypoint.sh` script + additionals server args.

## Configure

| **Env var name**           | **Description**                                                                   |
|----------------------------|-----------------------------------------------------------------------------------|
| `SKIP_PRIVILEGED`          | Skip cgroups sanitization (default: false)                                        |
| `LOG_FILE`                 | Docker daemon output log file within the container (default: /var/log/docker.log) |
| `STARTUP_TIMEOUT`          | Maximum time the script will wait for docker to start in seconds (default: 120)   |
| `MAX_CONCURRENT_DOWNLOADS` | To set the dockerd `--max-concurrent-downloads` arg (default: none)               |
| `MAX_CONCURRENT_UPLOADS`   | To set the dockerd `--max-concurrent-uploads` arg  (default: none)                |
| `INSECURE_REGISTRY`        | To set the dockerd `--insecure-registry` arg (default: none)                      |
| `REGISTRY_MIRROR`          | To set the dockerd `--registry-mirror` arg (default: none)                        |

## Usage in Concourse

```yaml
jobs:
  - name: my-job
    plan:
      - task: my-task
        privileged: true
        config:
          platform: linux
          image_resource:
            type: registry-image
            source:
              repository: cycloid/concourse-dind
              tag: latest
          run:
            path: concourse-dind-entrypoint.sh
            args:
              - 'bash'
              - '-ec'
              - |
                # Docker is started by the concourse-dind-entrypoint.sh entrypoint script

                # You can put here your code using docker

                # You can load docker images downloaded in advance by Concourse using the `docker_load` function
                source /opt/docker-utils.sh
                docker_load image_database/image.tar
                # or loading multiples images using GLOB
                docker_load "image_*/image.tar"
```

# Build manually

```bash
docker build -t cycloid/concourse-dind:manual .
```

