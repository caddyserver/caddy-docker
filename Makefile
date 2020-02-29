gen-dockerfiles: alpine/Dockerfile scratch/Dockerfile

%/Dockerfile: %/Dockerfile.base Dockerfile.tmpl
	@gomplate -d base=$< -f Dockerfile.tmpl -o $@

library/caddy: stackbrew.tmpl stackbrew-config.yaml */Dockerfile Dockerfile.tmpl
	@gomplate \
		--plugin fileCommit=./fileCommit.sh \
		-c conf=./stackbrew-config.yaml \
		-f $< \
		-o $@
