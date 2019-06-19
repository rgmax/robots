#!/bin/bash
set -ev

npm run build
git add build
if [[ $(git diff --cached --exit-code) ]]
    then
        git commit -m "chore(build-js): build on branch $TRAVIS_BRANCH [ci skip]"
        git push origin ${TRAVIS_BRANCH}
fi
