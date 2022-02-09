FROM nodeshift/ubi8-s2i-web-app


ENV OUTPUT_DIR="www"
USER root
# Copying in source code
COPY angular.json browserslist e2e ionic.config.json karma.conf.js manifests package.json package-lock.json src tsconfig.app.json tsconfig.json tsconfig.spec.json tslint.json VERSION  /tmp/src/
# Change file ownership to the assemble user. Builder image must support chown command.
RUN chown -R 1001:0 /tmp/src
USER 1001
# Assemble script sourced from builder image based on user input or image metadata.
# If this file does not exist in the image, the build will fail.
RUN /usr/libexec/s2i/assemble
# Run script sourced from builder image based on user input or image metadata.
# If this file does not exist in the image, the build will fail.
CMD /usr/libexec/s2i/run
FROM quay.io/hybridcloudpatterns/httpd-ionic
COPY --from=0 /opt/app-root/output /var/www/html/
