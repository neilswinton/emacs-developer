NOW:="$(shell date --iso-8601=seconds)"
TAG:="$(shell git branch --show-current | sed 's|/|-|g')"
REPO:="$(shell basename `git rev-parse --show-toplevel`)"

build:
	docker build								  \
		--build-arg BUILD_DATE="$(NOW)"					  \
		--build-arg VCS_REF="$(shell git rev-parse --short HEAD)"	  \
		--build-arg VCS_URL="$(shell git config --get remote.origin.url)" \
		 --tag "$(REPO):$(TAG)" .
