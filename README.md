# caddy-docker

A [Caddy Server](https://caddyserver.com/) (version 2) Docker image.

### Build

Dependency:
  - [Docker](https://www.docker.com/) (goto: [install instructions](https://docs.docker.com/install/))
  - [Go-Task](https://github.com/go-task/task) (goto: [install instructions](https://taskfile.dev/#/installation))

```
$ task --list
task: Available tasks for this project:
* d:build:      Build the Caddy Docker image
* d:lint:       Apply a Dockerfile linter (https://github.com/hadolint/hadolint)
```
