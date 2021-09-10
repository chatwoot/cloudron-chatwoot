FROM chatwoot/chatwoot:v1.19.0

ARG BUNDLE_WITHOUT="development:test"
ENV BUNDLE_WITHOUT ${BUNDLE_WITHOUT}
ENV BUNDLER_VERSION=2.1.2

ARG EXECJS_RUNTIME="Disabled"
ENV EXECJS_RUNTIME ${EXECJS_RUNTIME}

ARG RAILS_SERVE_STATIC_FILES=true
ENV RAILS_SERVE_STATIC_FILES ${RAILS_SERVE_STATIC_FILES}
 
ARG RAILS_ENV=production
ENV RAILS_ENV ${RAILS_ENV}
ENV BUNDLE_PATH="/gems"

RUN apk add --update --no-cache \
	supervisor	
RUN mkdir -p /var/log/supervisor

#create symlink
RUN mkdir -p /app/data/storage
RUN ln -s /app/data/storage /app/storage
RUN touch /tmp/supervisord.log

RUN rm -rf /app/tmp
RUN mkdir /tmp/puma
RUN ln -s /tmp/puma /app/tmp
##
RUN sed -e "s#REDIS_URL#CLOUDRON_REDIS_URL#" \
    -e "s#REDIS_PASSWORD#CLOUDRON_REDIS_PASSWORD#" \
    -i /app/config/cable.yml

RUN sed -e "s#REDIS_URL#CLOUDRON_REDIS_URL#" \
    -e "s#REDIS_PASSWORD#CLOUDRON_REDIS_PASSWORD#" \
    -i /app/lib/redis/config.rb

RUN sed -e "s/POSTGRES_DATABASE/CLOUDRON_POSTGRESQL_DATABASE/" \
    -e "s/POSTGRES_USERNAME/CLOUDRON_POSTGRESQL_USERNAME/" \
    -e "s/POSTGRES_PASSWORD/CLOUDRON_POSTGRESQL_PASSWORD/" \
    -e "s/POSTGRES_HOST/CLOUDRON_POSTGRESQL_HOST/" \
    -e "s/POSTGRES_PORT/CLOUDRON_POSTGRESQL_PORT/" \
    -i /app/config/database.yml

# add supervisor configs
ADD supervisor/* /etc/supervisor/conf.d/
ADD supervisord.conf /etc/supervisor/
ADD start.sh /app/start.sh
WORKDIR /app

CMD [ "/app/start.sh" ]

EXPOSE 3000
