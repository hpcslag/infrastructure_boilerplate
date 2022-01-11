#!/bin/sh
# Deletes artifacts from previous deployment.
# Used as BeforeInstall hook in CodeDeploy deployments.

set -e

rm -rf /tmp/go-deploy
