all: gen-dockerfiles library/caddy .github/dependabot.yml

gen-dockerfiles: render-dockerfiles.tmpl Dockerfile.tmpl Dockerfile.builder.tmpl Dockerfile.windows.tmpl Dockerfile.windows-builder.tmpl */*/Dockerfile.base
	@gomplate \
		--plugin getChecksums=./getChecksums.sh \
		-t dockerfile=Dockerfile.tmpl \
		-t builder-dockerfile=Dockerfile.builder.tmpl \
		-t windows-dockerfile=Dockerfile.windows.tmpl \
		-t windows-builder-dockerfile=Dockerfile.windows-builder.tmpl \
		-t caddy-builder=caddy-builder.sh.tmpl \
		-c config=./stackbrew-config.yaml \
		-f $<

library/caddy: stackbrew.tmpl stackbrew-config.yaml gen-dockerfiles
	@gomplate \
		--plugin fileCommit=./fileCommit.sh \
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
