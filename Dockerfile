FROM alpine:3.15.4

RUN apk update \
    && apk upgrade \
    && apk add --no-cache --virtual .build-deps wget

ARG GLIBC_VERSION=2.28-r0
ARG GLIBC_PREFIX=/usr/glibc-compat
ARG GLIBC_DOWNLOAD_BASE_URL=https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}

ENV LANG=en_US.UTF-8

# base glibc support
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -q $GLIBC_DOWNLOAD_BASE_URL/glibc-${GLIBC_VERSION}.apk \
    && wget -q $GLIBC_DOWNLOAD_BASE_URL/glibc-bin-${GLIBC_VERSION}.apk \
    && wget -q $GLIBC_DOWNLOAD_BASE_URL/glibc-i18n-${GLIBC_VERSION}.apk \
    && apk add glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk glibc-i18n-${GLIBC_VERSION}.apk --no-cache \
    && /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 \
    && echo "export LANG=$LANG" > /etc/profile.d/locale.sh \
    && rm -rf glibc-${GLIBC_VERSION}.apk glibc-bin-${GLIBC_VERSION}.apk glibc-i18n-${GLIBC_VERSION}.apk

# native libs required by Java
ARG EXT_GCC_LIBS_URL=https://archive.archlinux.org/packages/g/gcc-libs/gcc-libs-8.3.0-1-x86_64.pkg.tar.xz
ARG EXT_ZLIB_URL=https://archive.archlinux.org/packages/z/zlib/zlib-1%3A1.2.11-3-x86_64.pkg.tar.xz

RUN mkdir -p /tmp/zlib \
    && wget -q -O - "${EXT_ZLIB_URL}" | tar xJf - -C /tmp/zlib \
    && cp -dP /tmp/zlib/usr/lib/libz.so* "${GLIBC_PREFIX}/lib" \
    && rm -rf /tmp/zlib \
    && mkdir -p /tmp/gcc \
    && wget -q -O - "${EXT_GCC_LIBS_URL}" | tar xJf - -C /tmp/gcc \
    && cp -dP /tmp/gcc/usr/lib/libgcc* /tmp/gcc/usr/lib/libstdc++* "${GLIBC_PREFIX}/lib" \
    && rm -rf /tmp/gcc \
    && ${GLIBC_PREFIX}/sbin/ldconfig

# fix networking
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

ARG ECLIPSE_TEMURIN_DOWNLOAD_URL=https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.14.1%2B1/OpenJDK11U-jre_x64_linux_hotspot_11.0.14.1_1.tar.gz

RUN mkdir -p /opt/openjdk \
    && wget -q "$ECLIPSE_TEMURIN_DOWNLOAD_URL" -O /tmp/openjdk.tar.gz \
    && tar xf /tmp/openjdk.tar.gz --strip-components=1 -C /opt/openjdk \
    && rm -rf /tmp/openjdk.tar.gz

RUN apk del .build-deps \
    && rm -rf /var/cache/apk/*

ENV JAVA_HOME=/opt/openjdk
ENV PATH=$JAVA_HOME/bin:$PATH
