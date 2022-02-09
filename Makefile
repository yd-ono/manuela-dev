generate:
	OUTPUT_IMAGE=anomaly-detection ./generate.sh
	OUTPUT_IMAGE=software-sensor BUILDER_IMAGE=registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift ./generate.sh
	OUTPUT_IMAGE=messaging BUILD_PATH=components/iot-consumer BUILDER_IMAGE=registry.access.redhat.com/rhscl/nodejs-10-rhel7 ./generate.sh
	OUTPUT_IMAGE=frontend BUILDER_IMAGE=nodeshift/ubi8-s2i-web-app CHAINED_BUILD_DOCKERFILE="FROM quay.io/hybridcloudpatterns/httpd-ionic\nCOPY --from=0 /opt/app-root/output /var/www/html/" ./generate.sh
