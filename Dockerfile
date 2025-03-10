FROM python:3.10-alpine

RUN adduser -D ldap

WORKDIR /home/ldap

RUN apk add --no-cache \
    gcc \
    g++ \
    musl-dev

COPY requirements.txt requirements.txt
RUN python -m venv venv
RUN venv/bin/pip install -r requirements.txt --no-cache-dir

COPY app app
COPY migrations migrations
COPY ldap.py config.py boot.sh ./
RUN set -x \
    && chmod +x boot.sh \
    && mkdir -p /home/ldap/db \
    && chown -R ldap:ldap ./

ENV FLASK_APP ldap.py

USER ldap

VOLUME ["/home/ldap/db"]

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
