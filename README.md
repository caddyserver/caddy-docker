# caddy-docker

A [Caddy Server](https://caddyserver.com/) (version 2) Docker image.

Dependencies:
  - [Docker](https://www.docker.com/) ([install instructions](https://docs.docker.com/install/))
  - [Go-Task](https://github.com/go-task/task) ([install instructions](https://taskfile.dev/#/installation))

```
$ task --list

task: Available tasks for this project:
* d:build:alpine:       Build a Caddy Alpine-based Docker image
* d:build:scratch:      Build a Caddy scratch-based Docker image
* d:lint:               Apply a Dockerfile linter (https://github.com/hadolint/hadolint)
* d:run:alpine:         Build and run the Caddy alpine-based Docker image
* d:run:scratch:        Build and run the Caddy scratch-based Docker image
```
