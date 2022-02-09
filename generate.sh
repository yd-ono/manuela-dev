#!/bin/bash -e

: ${OUTPUT_IMAGE:="anomaly-detection"}
: ${BUILD_PATH:="components/iot-$OUTPUT_IMAGE"}
: ${BUILDER_IMAGE:="registry.access.redhat.com/rhscl/python-36-rhel7"}
: ${ARTIFACTS:="$PWD/.build"}
: ${CHAINED_BUILD_DOCKERFILE:=""}
: ${LOGLEVEL:="0"}
: ${TLSVERIFY:="false"}

if [ -d .build ]; then
    rm -rf .build
fi
mkdir .build

if [[ "$BUILDER_IMAGE)" == *"jdk"* ]] || [[ "$BUILDER_IMAGE)" == *"java"* ]]; then
    echo "MAVEN_CLEAR_REPO=$MAVEN_CLEAR_REPO" > $ARTIFACTS/env-file
    [[ '$MAVEN_ARGS_APPEND)' != "" ]] &&
        echo "MAVEN_ARGS_APPEND=$MAVEN_ARGS_APPEND" >> $ARTIFACTS/env-file
    [[ '$MAVEN_MIRROR_URL)' != "" ]] &&
        echo "MAVEN_MIRROR_URL=$MAVEN_MIRROR_URL" >> $ARTIFACTS/env-file
    #create build artifacts cache directory
    if [[ ! -d $ARTIFACTS/m2 ]]; then
        mkdir -p $ARTIFACTS/m2
        chmod a+rwx $ARTIFACTS/m2
    fi
    echo "MAVEN_LOCAL_REPO=/ba/m2" >> $ARTIFACTS/env-file
    echo "Generated Env file"
    echo "------------------------------"
    cat $ARTIFACTS/env-file
    echo "------------------------------"
    podman run -v ./$BUILD_PATH:/sources -v .build:/output quay.io/openshift-pipeline/s2i build --loglevel=$LOGLEVEL /sources $BUILDER_IMAGE --image-scripts-url image:///usr/local/s2i --as-dockerfile /output/Dockerfile.gen --environment-file /output/env-file
    if [[ -n "$CHAINED_BUILD_DOCKERFILE" ]]; then
	echo -e "$CHAINED_BUILD_DOCKERFILE" >> $ARTIFACTS/Dockerfile.gen
    fi
    #buildah bud --tls-verify=$TLSVERIFY --storage-driver=vfs -f $ARTIFACTS/Dockerfile.gen -t $OUTPUT_IMAGE -v $ARTIFACTS/m2:/ba/m2 .
else
    podman run -v ./$BUILD_PATH:/sources -v .build:/output quay.io/openshift-pipeline/s2i build --loglevel=$LOGLEVEL /sources $BUILDER_IMAGE --as-dockerfile /output/Dockerfile.gen
    FILES=$(ls -1 $BUILD_PATH | grep -v -e Dockerfile -e '~' -e scripts | tr '\n' ' ')
    sed -e 's/.*io.openshift.s2i.build.*//g' -e "s@upload/src /tmp/src@$FILES /tmp/src/@" -e "s@upload/scripts@scripts@" -i .build/Dockerfile.gen
    if [[ -n "$CHAINED_BUILD_DOCKERFILE" ]]; then
	echo -e "$CHAINED_BUILD_DOCKERFILE" >> .build/Dockerfile.gen
    fi
    #buildah bud --tls-verify=$TLSVERIFY --storage-driver=vfs -f $ARTIFACTS//Dockerfile.gen -t $OUTPUT_IMAGE .    
fi
cp .build/Dockerfile.gen $BUILD_PATH/Dockerfile
ls -1 .build/upload/scripts
cp -r .build/upload/scripts $BUILD_PATH/
#cat $BUILD_PATH/Dockerfile
rm -rf .build
