#!/bin/bash
set -ev

# Install google cloud SDK and kubectl
if [[ ! -d "$HOME/google-cloud-sdk/bin" ]]; then rm -rf "$HOME/google-cloud-sdk"; curl https://sdk.cloud.google.com | bash > /dev/null; fi
source $HOME/google-cloud-sdk/path.bash.inc
gcloud components update kubectl
gcloud version

# Authentication process
gcloud config set account travis@tipi-staging-micro-services.iam.gserviceaccount.com
gcloud auth activate-service-account --key-file=tipi-staging-micro-services-91d8a0a468e1.json
gcloud container clusters get-credentials cluster-stg-sydney --zone australia-southeast1-a --project tipi-staging-micro-services

# Deploy built version
SERVICE_VERSION=$(node -p "require('./package.json').version")
kubectl --record deployment.apps/robots set image deployment.v1.apps/robots robots=rgmax/robots:${SERVICE_VERSION}
