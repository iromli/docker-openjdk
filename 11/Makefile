# default image name
IMAGE_NAME?=iromli/openjdk
VERSION=$(shell cat version.txt)

.DEFAULT_GOAL:=build-jre

.PHONY: build-jre build-jdk test clean all

build-jre:
	@echo "[I] Building image ${IMAGE_NAME}:jre-${VERSION}"
	@docker build --rm --force-rm -t ${IMAGE_NAME}:jre-${VERSION} .

build-jdk:
	@echo "[I] Building image ${IMAGE_NAME}:jdk-${VERSION}"
	@docker build --rm --force-rm --build-arg OPENJDK_VARIANT=jdk -t ${IMAGE_NAME}:jdk-${VERSION} .
