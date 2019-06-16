#!/bin/bash
set -ev

if [[ ! -d "$HOME/google-cloud-sdk/bin" ]]; then rm -rf "$HOME/google-cloud-sdk"; curl https://sdk.cloud.google.com | bash > /dev/null; fi
source $HOME/google-cloud-sdk/path.bash.inc
gcloud components update kubectl
gcloud version

gcloud config set account travis@tipi-staging-micro-services.iam.gserviceaccount.com
gcloud auth activate-service-account --key-file=tipi-staging-micro-services-91d8a0a468e1.json
kubectl config get-contexts