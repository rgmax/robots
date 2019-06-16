#!/bin/bash
set -ev

if [[ ${TEST_BRANCH_NAME} =~ ^release.*$ || ${TEST_BRANCH_NAME} == master ]]
then
    # Load configuration
    . scripts/config.common
    if [[ ${TEST_BRANCH_NAME} == master ]]
        then
            . scripts/config.production
        else
            . scripts/config.staging
    fi

    # Update version and push to branch
    git checkout ${TRAVIS_BRANCH}
    yarn release ${STANDARD_VERSION_ARGS}
    git remote set-url origin git@github.com:${TRAVIS_REPO_SLUG}.git
    git push ${GIT_PUSH_ARGS} origin ${TRAVIS_BRANCH}

    # Log into docker account
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

    # Build & push docker image
    SERVICE_VERSION=$(node -p "require('./package.json').version")
    docker build -t ${APP_DOCKER_IMAGE_NAME}:${SERVICE_VERSION} .
    docker push ${APP_DOCKER_IMAGE_NAME}:${SERVICE_VERSION}
fi
