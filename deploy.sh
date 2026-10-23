#!/bin/bash
# Deploys /opt/website/site to Nginx. Safe to run again and again.
set -e
REPO_DIR=/opt/website
WEB_ROOT=/var/www/html
cd "$REPO_DIR"
git fetch --quiet origin main
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)
if [ "$LOCAL" != "$REMOTE" ] || [ ! -f "$WEB_ROOT/.deployed" ]; then
  git reset --hard --quiet origin/main
  rm -rf "$WEB_ROOT"/*
  cp -r site/* "$WEB_ROOT"/
  COMMIT=$(git rev-parse --short HEAD)
  NOW=$(date -u '+%Y-%m-%d %H:%M UTC')
  sed -i "s/{{HOSTNAME}}/$(hostname)/g; s/{{COMMIT}}/$COMMIT/g; s/{{DEPLOYED}}/$NOW/g" "$WEB_ROOT/index.html"
  touch "$WEB_ROOT/.deployed"
  echo "$(date -u) deployed $COMMIT"
fi
