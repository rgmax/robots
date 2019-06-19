#!/bin/bash
set -ev

git checkout ${TRAVIS_BRANCH}
git remote set-url origin git@github.com:${TRAVIS_REPO_SLUG}.git
