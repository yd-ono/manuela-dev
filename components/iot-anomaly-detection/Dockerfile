FROM registry.access.redhat.com/rhscl/python-36-rhel7


ENV MODEL_NAME="AnomalyDetection" \
    API_TYPE="REST" \
    SERVICE_TYPE="MODEL" \
    PERSISTENCE="0"
USER root
# Copying in override assemble/run scripts
COPY scripts /tmp/scripts
# Copying in source code
COPY AnomalyDetection.py LICENSE Makefile manifests model.joblib README.md requirements.txt VERSION  /tmp/src/
# Change file ownership to the assemble user. Builder image must support chown command.
RUN chown -R 1001:0 /tmp/scripts /tmp/src
USER 1001
# Assemble script sourced from builder image based on user input or image metadata.
# If this file does not exist in the image, the build will fail.
RUN /usr/libexec/s2i/assemble
CMD /tmp/scripts/run
