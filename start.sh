#!/bin/sh

set -x

# sed -e "s#REDIS_URL#redis://user:${CLOUDRON_REDIS_PASSWORD}@${CLOUDRON_REDIS_HOST}:${CLOUDRON_REDIS_PORT}#" \
#     -e "s#REDIS_PASSWORD#${CLOUDRON_REDIS_PASSWORD}#" \
#     -i /app/config/cable.yml

# sed -e "s/POSTGRES_DATABASE/${CLOUDRON_POSTGRESQL_DATABASE}/" \
#     -e "s/POSTGRES_USERNAME/${CLOUDRON_POSTGRESQL_USERNAME}/" \
#     -e "s/POSTGRES_PASSWORD/${CLOUDRON_POSTGRESQL_PASSWORD}/" \
#     -e "s/POSTGRES_HOST/${CLOUDRON_POSTGRESQL_HOST}/" \
#     -e "s/POSTGRES_PORT/${CLOUDRON_POSTGRESQL_PORT}/" \
#     -i /app/config/database.yml

if [[ ! -f "/app/data/.dbsetup" ]]; then
    echo "==> Initializing db"
    bundle exec rails db:chatwoot_prepare RAILS_ENV=production
    touch /app/data/.dbsetup
else
    echo "==> Upgrading existing db"
    bundle exec rails db:chatwoot_prepare RAILS_ENV=production
fi


echo "==> Starting supervisor"
exec /usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf
