FROM alpine:3.10

LABEL maintainer devops@travelaudience.com

# java
ENV JAVA_HOME=/usr/lib/jvm/default-jvm/jre

# nexus
ENV NEXUS_VERSION 3.15.2-01
ENV NEXUS_DOWNLOAD_URL "https://download.sonatype.com/nexus/3"
ENV NEXUS_TARBALL_URL "${NEXUS_DOWNLOAD_URL}/nexus-${NEXUS_VERSION}-unix.tar.gz"
ENV NEXUS_TARBALL_ASC_URL "${NEXUS_DOWNLOAD_URL}/nexus-${NEXUS_VERSION}-unix.tar.gz.asc"
ENV GPG_KEY 0374CF2E8DD1BDFD

ENV SONATYPE_DIR /opt/sonatype
ENV NEXUS_HOME "${SONATYPE_DIR}/nexus"
ENV NEXUS_DATA /nexus-data
ENV NEXUS_CONTEXT ''
ENV SONATYPE_WORK ${SONATYPE_DIR}/sonatype-work
# uncomment the following and enter the Okta account name
ENV YOUR_ACCOUNT guidespark

# Install prerequisites
RUN apk add --no-cache --update bash ca-certificates runit su-exec util-linux openjdk8-jre

# Install nexus
RUN apk add --no-cache -t .build-deps wget gnupg openssl \
  && cd /tmp \
  && echo "===> Installing Nexus ${NEXUS_VERSION}..." \
  && wget -O nexus.tar.gz $NEXUS_TARBALL_URL; \
  wget -O nexus.tar.gz.asc $NEXUS_TARBALL_ASC_URL; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys $GPG_KEY; \
    gpg --batch --verify nexus.tar.gz.asc nexus.tar.gz; \
    rm -r $GNUPGHOME nexus.tar.gz.asc; \
  tar -xf nexus.tar.gz \
  && mkdir -p $SONATYPE_DIR \
  && mv nexus-$NEXUS_VERSION $NEXUS_HOME \
  && cd $NEXUS_HOME \
  && ls -las \
  && adduser -h $NEXUS_DATA -DH -s /sbin/nologin nexus \
  && chown -R nexus:nexus $NEXUS_HOME \
  && rm -rf /tmp/* /var/cache/apk/* \
  && apk del --purge .build-deps

# Configure nexus
RUN sed \
    -e '/^nexus-context/ s:$:${NEXUS_CONTEXT}:' \
    -i ${NEXUS_HOME}/etc/nexus-default.properties \
  && sed \
    -e '/^-Xms/d' \
    -e '/^-Xmx/d' \
    -i ${NEXUS_HOME}/bin/nexus.vmoptions

RUN mkdir -p ${NEXUS_DATA}/etc ${NEXUS_DATA}/log ${NEXUS_DATA}/tmp ${SONATYPE_WORK} \
  && ln -s ${NEXUS_DATA} ${SONATYPE_WORK}/nexus3 \
  && chown -R nexus:nexus ${NEXUS_DATA}


# install plugins
RUN apk update && \
    apk add curl && \
    curl -L \
    https://github.com/ruhkopf/nexus-okta-auth-plugin/releases/download/0.0.3/nexus-okta-auth-plugin-0.0.3.jar --output /opt/sonatype/nexus/system/nexus-okta-auth-plugin.jar && \
    echo "reference\:file\:nexus-okta-auth-plugin.jar = 200" >> /opt/sonatype/nexus/etc/karaf/startup.properties && \
    touch /opt/sonatype/nexus/etc/nexus-okta-auth.properties && \
    echo "okta.org.url=https://${YOUR_ACCOUNT}.okta.com/" >> /opt/sonatype/nexus/etc/nexus-okta-auth.properties && \
    chown nexus:nexus -R /opt/sonatype/nexus && \
    rm -rf /var/cache/apk

# Update logback configuration to store 30 days logs rather than 90 days default
RUN sed -i -e 's|<maxHistory>90</maxHistory>|<maxHistory>30</maxHistory>|g' ${NEXUS_HOME}/etc/logback/logback*.xml

# Copy runnable script
COPY run /etc/service/nexus/run

VOLUME ${NEXUS_DATA}

EXPOSE 8081 1111

WORKDIR ${NEXUS_HOME}

ENV INSTALL4J_ADD_VM_PARAMS="-Xms1200m -Xmx1200m"

CMD ["/sbin/runsvdir", "-P", "/etc/service"]
