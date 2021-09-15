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

# Remove a potentially pre-existing server.pid for Rails.
rm -rf /app/tmp/pids/server.pid
rm -rf /app/tmp/cache/*

echo "Waiting for postgres to become ready...."

PG_READY="pg_isready -h $CLOUDRON_POSTGRESQL_HOST -p $CLOUDRON_POSTGRESQL_PORT"

until $PG_READY
do
  sleep 2;
done

echo "Database ready to accept connections."

if [[ ! -f "/app/data/.env" ]]; then
  echo "Creating .env file at /app/data/.env"
  cp /app/.env.example /app/data/.env
else
  echo "Skipping .env file creation. /app/data/.env exists."
fi

if [[ ! -f "/app/data/.dbsetup" ]]; then
    echo "==> Initializing db"
    bundle exec rails db:chatwoot_prepare RAILS_ENV=production
    touch /app/data/.dbsetup
else
    echo "==> Upgrading existing db"
    bundle exec rails db:chatwoot_prepare RAILS_ENV=production
fi

# bundle install

BUNDLE="bundle check"

until $BUNDLE
do
  sleep 2;
done

echo "==> Starting supervisor"
exec /usr/bin/supervisord --configuration /etc/supervisor/supervisord.conf
