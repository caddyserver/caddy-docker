gen-dockerfiles: alpine/Dockerfile scratch/Dockerfile

builder/Dockerfile: builder/Dockerfile.tmpl stackbrew-config.yaml
	@gomplate -c config=./stackbrew-config.yaml -f builder/Dockerfile.tmpl -o $@

%/Dockerfile: %/Dockerfile.base Dockerfile.tmpl
	@gomplate -d base=$< -f Dockerfile.tmpl -o $@

library/caddy: stackbrew.tmpl stackbrew-config.yaml */Dockerfile Dockerfile.tmpl
	@gomplate \
		--plugin fileCommit=./fileCommit.sh \
		-c conf=./stackbrew-config.yaml \
		-f $< \
		-o $@
