FROM nginx:alpine

RUN apk add --no-cache gettext

WORKDIR /opt

COPY auth.conf auth.htpasswd launch.sh ./

ENV HTPASSWD='foo:$apr1$odHl5EJN$KbxMfo86Qdve2FH4owePn.' \
    FORWARD_PORT=80 \
    FORWARD_HOST=web \
    NGINX_PORT=80 \
    HEALTH_ENDPOINT='/healthz'


# make sure root login is disabled
RUN sed -i -e 's/^root::/root:!:/' /etc/shadow

CMD ["./launch.sh"]
