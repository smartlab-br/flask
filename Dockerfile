FROM python:3.10-slim
LABEL maintainer="smartlab-dev@mpt.mp.br"

# ENV PYTHONPATH /app:/usr/lib/python3.8/site-packages
COPY requirements.txt /app/requirements.txt

RUN apt-get update  && \
    apt-get upgrade -y  && \
    apt-get install -y build-essential gcc libpcre3 libpcre3-dev && \
    pip3 install -r /app/requirements.txt && \
    mkdir -p /var/run/flask && \
    groupadd -r uwsgi && useradd -r -g uwsgi uwsgi && \
    chown -R uwsgi:uwsgi /var/run/flask && \
    apt-get --purge remove -y gcc && \
    apt-get clean

ENV LANG C.UTF-8
ENV DEBUG 0
ENV FLASK_APP /app/main.py

EXPOSE 5000

COPY --chown=uwsgi:uwsgi app/*.py /app/
COPY --chown=uwsgi:uwsgi uwsgi.ini /etc/uwsgi/conf.d/
COPY --chown=uwsgi:uwsgi start.sh /start.sh

WORKDIR /app

ENTRYPOINT ["sh", "/start.sh"]
