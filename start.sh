#!/bin/sh

set -x

sed -e "s#REDIS_URL#redis://user:${CLODURON_REDIS_PASSWORD}@${CLODURON_REDIS_HOST}:${CLODURON_REDIS_PORT}#" \
    -e "s#REDIS_PASSWORD#${CLODURON_REDIS_PASSWORD}#" \
    /app/config/cable.yaml


echo "==> Starting supervisor"
exec /usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf
