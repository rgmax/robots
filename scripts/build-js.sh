#!/bin/bash
set -ev

npm run build
git add build
git commit -m "chore(build-js): build on branch $TRAVIS_BRANCH"
git push origin ${TRAVIS_BRANCH}
