#!/bin/bash
set -ev

git checkout ${TRAVIS_BRANCH}
yarn release
git remote set-url origin git@github.com:${TRAVIS_REPO_SLUG}.git
git push --follow-tags origin ${TRAVIS_BRANCH}
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
SERVICE_VERSION=$(node -p "require('./package.json').version")
docker build -t rgmax/robots:${SERVICE_VERSION} .
docker push rgmax/robots:${SERVICE_VERSION}
