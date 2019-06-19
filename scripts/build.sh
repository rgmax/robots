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

    # Check if build is enabled
    if [[ ${BUILD_ENABLED} == true ]]
        then
            # Update version and push to branch
            yarn release ${STANDARD_VERSION_ARGS}
            git push ${GIT_PUSH_ARGS} origin ${TRAVIS_BRANCH}

            # Log into docker account
            echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

            # Build & push docker image
            SERVICE_VERSION=$(node -p "require('./package.json').version")
            docker build -t ${APP_DOCKER_IMAGE_NAME}:${SERVICE_VERSION} .
            docker push ${APP_DOCKER_IMAGE_NAME}:${SERVICE_VERSION}
    fi
fi
