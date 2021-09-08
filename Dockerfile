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

# add supervisor configs
ADD supervisor/* /etc/supervisor/conf.d/
ADD supervisord.conf /etc/supervisor/
ADD start.sh /app/start.sh
WORKDIR /app

CMD [ "/app/start.sh" ]

EXPOSE 3000
