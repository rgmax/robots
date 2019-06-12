#!/bin/bash
set -ev

yarn release
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
VERSION=$(node -p "require('./package.json').version")
docker build -t rgmax/robots:${VERSION} .
docker push rgmax/robots:${VERSION}
