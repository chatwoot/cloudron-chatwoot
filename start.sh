#!/bin/sh

set -x

echo "==> Starting supervisor"

exec /usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf
