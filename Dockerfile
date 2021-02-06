FROM python:3.6-alpine

RUN apk add --no-cache --virtual .build-deps linux-headers gcc musl-dev\
  && apk add --no-cache libffi-dev openssl-dev dialog\
  && pip install certbot\
  && apk del .build-deps\
  && mkdir /scripts\
  && pip install certbot-dns-cloudflare certbot-dns-digitalocean 

ADD crontab /etc/crontabs
RUN crontab /etc/crontabs/crontab

COPY ./scripts/ /scripts
RUN chmod +x /scripts/run_certbot.sh

ENTRYPOINT ["/scripts/run_certbot.sh"]
CMD ["crond", "-f"]