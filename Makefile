# default target is gen-dockerfiles
.DEFAULT_GOAL := gen-dockerfiles

all: gen-dockerfiles library/caddy .github/dependabot.yml

gen-dockerfiles: tmpl/render-dockerfiles.tmpl tmpl/Dockerfile.tmpl tmpl/Dockerfile.builder.tmpl tmpl/Dockerfile.windows.tmpl tmpl/Dockerfile.windows-builder.tmpl tmpl/Dockerfile.nanoserver.tmpl */*/Dockerfile.base
	@gomplate \
		--plugin getChecksums=./scripts/getChecksums.sh \
		-t dockerfile=tmpl/Dockerfile.tmpl \
		-t builder-dockerfile=tmpl/Dockerfile.builder.tmpl \
		-t windows-dockerfile=tmpl/Dockerfile.windows.tmpl \
		-t windows-builder-dockerfile=tmpl/Dockerfile.windows-builder.tmpl \
		-t nanoserver-dockerfile=tmpl/Dockerfile.nanoserver.tmpl \
		-t caddy-builder=tmpl/caddy-builder.sh.tmpl \
		-c config=./stackbrew-config.yaml \
		-f $<

library/caddy: tmpl/stackbrew.tmpl stackbrew-config.yaml gen-dockerfiles
	@gomplate \
		--plugin fileCommit=./scripts/fileCommit.sh \
		-c config=./stackbrew-config.yaml \
		-f $< \
		-o $@
	@touch $@

.github/dependabot.yml: .github/dependabot.yml.tmpl $(shell find . -name 'Dockerfile.base')
	@gomplate -f $< -o $@
	@touch $@

.PHONY: all gen-dockerfiles
.DELETE_ON_ERROR:
.SECONDARY:
