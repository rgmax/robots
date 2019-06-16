#!/bin/bash
set -ev

if [[ ${TRAVIS_BRANCH} =~ ^release.*$ || ${TRAVIS_BRANCH} == master ]]
then
    # Load configuration
    . scripts/config.common
    if [[ ${TRAVIS_BRANCH} == master ]]
        then
            . scripts/config.production
        else
            . scripts/config.staging
    fi

    # Install google cloud SDK and kubectl
    if [[ ! -d "$HOME/google-cloud-sdk/bin" ]]; then rm -rf "$HOME/google-cloud-sdk"; curl https://sdk.cloud.google.com | bash > /dev/null; fi
    source $HOME/google-cloud-sdk/path.bash.inc
    gcloud components update kubectl
    gcloud version

    # Authentication process
    gcloud config set account ${CLOUD_SERVICE_ACCOUNT_EMAIL}
    gcloud auth activate-service-account --key-file=${CLOUD_SERVICE_ACCOUNT_KEY_FILE}
    gcloud container clusters get-credentials ${CLOUD_CLUSTER_NAME} --zone ${CLOUD_CLUSTER_ZONE} --project ${CLOUD_CLUSTER_PROJECT}

    # Deploy built version
    SERVICE_VERSION=$(node -p "require('./package.json').version")
    kubectl --record deployment.apps/${APP_DEPLOYMENT_NAME} set image deployment.v1.apps/${APP_DEPLOYMENT_NAME} ${APP_CONTAINER_NAME}=${APP_DOCKER_IMAGE_NAME}:${SERVICE_VERSION}
fi
