[![caddy on DockerHub][dockerhub-image]][dockerhub-url]
[![Docker Build][gh-actions-image]][gh-actions-url]

# [caddy](https://hub.docker.com/_/caddy)

This is the repo where the official `caddy` Docker image sources live.

**Please see https://hub.docker.com/_/caddy for documentation.**

If you have an issue or suggestion for the Docker image, please [open an issue](https://github.com/caddyserver/caddy-docker/issues/new).

If you'd like to suggest updates to the [image documentation](https://hub.docker.com/_/caddy), see https://github.com/docker-library/docs/tree/master/caddy.

## Release instructions (for maintainers)

The release process is currently semi-automated, held together with shell scripts and gomplate (and duct tape).

1. update the `stackbrew-config.yaml` file (update `caddy_version`) and save
2. run `make` (note that you'll need [`gomplate`](https://docs.gomplate.ca/installing/) on your path)
3. commit all changed Dockerfiles and `stackbrew-config.yaml` and issue a PR
    - note: revert the `library/caddy` file if it's changed
4. once the CI passes and the PR is merged, pull and run `make` again - this should update the `library/caddy` file
5. commit the updated `library/caddy` file and push directly to `master`
6. Finally, issue a PR to https://github.com/docker-library/official-images containing the updated `library/caddy` file (copied into `official-images/library/caddy`)

## License

View [license information](https://github.com/caddyserver/caddy/blob/master/LICENSE) for the software contained in this image.

[gh-actions-image]: https://github.com/caddyserver/caddy-docker/workflows/Docker%20Build/badge.svg?branch=master
[gh-actions-url]: https://github.com/caddyserver/caddy-docker/actions?workflow=Docker%20Build&branch=master

[dockerhub-image]: https://img.shields.io/badge/docker-ready-blue.svg
[dockerhub-url]: https://hub.docker.com/_/caddy
