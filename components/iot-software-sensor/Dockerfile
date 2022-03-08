FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift
LABEL "io.openshift.s2i.build.image"="registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift" \
      "io.openshift.s2i.build.source-location"="/sources"
ENV MAVEN_CLEAR_REPO="" \
    MAVEN_ARGS_APPEND="" \
    MAVEN_MIRROR_URL="" \
    MAVEN_LOCAL_REPO="/ba/m2"
USER root
# Copying in source code
COPY upload/src /tmp/src
# Change file ownership to the assemble user. Builder image must support chown command.
RUN chown -R 1001:0 /tmp/src
USER 1001
# Assemble script sourced from builder image based on user input or image metadata.
# If this file does not exist in the image, the build will fail.
RUN /usr/local/s2i/assemble
# Run script sourced from builder image based on user input or image metadata.
# If this file does not exist in the image, the build will fail.
CMD /usr/local/s2i/run
