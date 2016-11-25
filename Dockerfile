FROM java:openjdk-7-jdk-alpine

ENV     RDECK_BASE=/opt/rundeck
ENV     RDECK_JAR=$RDECK_BASE/app.jar
ENV     PATH=$PATH:$RDECK_BASE/tools/bin
RUN     apk add --update bash curl && \
        mkdir -p $RDECK_BASE && \
        wget -O $RDECK_JAR \
            http://dl.bintray.com/rundeck/rundeck-maven/rundeck-launcher-2.6.8.jar && \
        rm -Rf /var/cache/apk/*
		
ENV TINI_SHA 066ad710107dc7ee05d3aa6e4974f01dc98f3888

# Use tini as subreaper in Docker container to adopt zombie processes 
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v0.5.0/tini-static -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha1sum -c -

COPY    files/run.sh /bin/rundeck
EXPOSE  4440
VOLUME  /opt/rundeck
CMD     rundeck
ENTRYPOINT ["/bin/tini", "--", "/opt/rundeck/rundeck"]