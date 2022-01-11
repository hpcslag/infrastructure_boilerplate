#!/usr/bin/env bash

# Deploys a Golang application locally, deleting previous revisions.
# Used as AfterInstall hook in CodeDeploy deployments.

set -e

export GO_ENV="${GO_ENV:-prod}"
APP_NAME=[your app name]
SOURCE_BINARY=[your binary app filename]

DEPLOY_USER=deploy
APP_GROUP=app

SRCDIR="/tmp/go-deploy"
DESTDIR="/usr/local/lib/$APP_NAME/"
CURRENT_LINK="${DESTDIR}current"
MAX_PAST_RELEASES=6
RELEASE_NAME="$APP_NAME"

TIMESTAMP=$(date +%Y%m%d%H%M%S)
RELEASE_DIR="${DESTDIR}releases/${TIMESTAMP}"

cd "$SRCDIR"
mkdir -p "$RELEASE_DIR"
echo "===> Copying binary to release directory"
cp "$SRCDIR/$SOURCE_BINARY" "$RELEASE_DIR/"
sudo chown -R ${DEPLOY_USER}:${APP_GROUP} "${RELEASE_DIR}"
sudo chmod -R 777 "${DESTDIR}"

if [[ -L "$CURRENT_LINK" ]]; then
    echo "===> $CURRENT_LINK exists, unlinking..."
    rm "$CURRENT_LINK"
fi

echo "===> Linking $CURRENT_LINK to $RELEASE_DIR"
ln -s "$RELEASE_DIR" "$CURRENT_LINK"

echo "===> Restarting $APP_NAME systemd unit..."
sudo /bin/systemctl restart "$APP_NAME"
echo "===> Restarted!"

echo "===> Purging old releases"
# Remove old releases, leaving only the most recent
find ${DESTDIR}releases/ -maxdepth 1 -mindepth 1 -type d | sort -n | head -n -$MAX_PAST_RELEASES | xargs rm -rf
echo "OK"

exit 0
