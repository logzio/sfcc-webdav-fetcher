FROM node:current-alpine
USER root

# RUN apk add --no-cache --update git \
# 	&& git clone https://github.com/logzio/cctail.git cctail

ADD /cctail-fork /cctail

WORKDIR /cctail
RUN npm install

FROM fluent/fluentd:edge
USER root

RUN apk add --no-cache --update --virtual .build-deps \
	sudo build-base ruby-dev \
	&& apk add --update nodejs supervisor \
	&& sudo gem install fluent-plugin-logzio fluent-plugin-grok-parser \
	&& sudo gem sources --clear-all \
	&& apk del .build-deps \
	&& rm -rf /home/fluent/.gem/ruby/2.5.0/cache/*.gem

COPY entrypoint.sh /bin/
COPY fluent.conf /fluentd/etc/


COPY supervisord.conf /etc/supervisord.conf
COPY --from=0 cctail cctail
COPY log.conf-docker.json ./log.conf.json
COPY app.js /app.js
COPY grokPatternListInternal.json /grokPatternListInternal.json

ENV LOGZIO_SLOW_FLUSH_LOG_THRESHOLD "20.0"

# CMD [ "node", "app.js" ]