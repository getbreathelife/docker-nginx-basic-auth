FROM nginx:alpine

RUN apk add --no-cache gettext

WORKDIR /opt

COPY auth.conf auth.htpasswd launch.sh ./

ENV HTPASSWD='foo:$apr1$odHl5EJN$KbxMfo86Qdve2FH4owePn.' \
    FORWARD_PORT=80 \
    FORWARD_HOST=web \
    NGINX_PORT=8080 \
    HEALTH_ENDPOINT='/healthz'

# make sure root login is disabled
RUN sed -i -e 's/^root::/root:!:/' /etc/shadow

# give same permission of owner to group and assign owner to nginx user
# this allows the container to run in k8s cluster with non-root user as well as separately without the need to specify a non-root user id 
RUN touch /var/run/nginx.pid && \
  chmod -R g=u /var/run/nginx.pid && \
  chmod -R g=u /var/cache/nginx && \
  chmod -R g=u /etc/nginx/ && \
  chown -R nginx /var/run/nginx.pid && \
  chown -R nginx /var/cache/nginx && \
  chown -R nginx /etc/nginx/

USER nginx

CMD ["./launch.sh"]
