# Overview

Eclipse Temurin (OpenJDK) on Alpine with `glibc` support.

## Versions

Current version is `11.0.15`.

Supported variants:

- `jre`
- `jdk`

## Building Image

There are several options to build the image:

1.  Default image name

    - run `make` to build JRE variant
    - run `make build-jdk` to build JDK variant

1.  Custom image name by passing `IMAGE_NAME` value

    - run `make IMAGE_NAME=<custom-image-name>` for JRE variant
    - run `make build-jdk IMAGE_NAME=<custom-image-name>` for JDK variant
