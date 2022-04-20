# default image name
IMAGE_NAME?=janssenproject/openjdk
VERSION=$(shell cat version.txt)

build-jre:
	@echo "[I] Building image ${IMAGE_NAME}:jre-${VERSION}"
	@docker build --rm --force-rm -t ${IMAGE_NAME}:jre-${VERSION} .

build-jdk:
	@echo "[I] Building image ${IMAGE_NAME}:jdk-${VERSION}"
	@docker build --rm --force-rm --build-arg OPENJDK_VARIANT=jdk -t ${IMAGE_NAME}:jdk-${VERSION} .
