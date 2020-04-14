all: gen-dockerfiles library/caddy

gen-dockerfiles: alpine/Dockerfile builder/Dockerfile

builder/Dockerfile: builder/Dockerfile.base Dockerfile.builder.tmpl stackbrew-config.yaml
	@gomplate -d base=$< -c config=./stackbrew-config.yaml -f Dockerfile.builder.tmpl -o $@

%/Dockerfile: %/Dockerfile.base Dockerfile.tmpl stackbrew-config.yaml
	@gomplate -d base=$< -c config=./stackbrew-config.yaml -f Dockerfile.tmpl -o $@

library/caddy: stackbrew.tmpl stackbrew-config.yaml */Dockerfile Dockerfile.tmpl
	@gomplate \
		--plugin fileCommit=./fileCommit.sh \
		-c conf=./stackbrew-config.yaml \
		-f $< \
		-o $@

.PHONY: all gen-dockerfiles
.DELETE_ON_ERROR:
.SECONDARY:
