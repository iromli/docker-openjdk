VERSION=11.0.14.1

build-dev:
	@docker build --rm --force-rm -t iromli/alpine-jre-glibc:${VERSION} .
