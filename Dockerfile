FROM alpine

# Dependencies
RUN apk --update add --no-cache lighttpd
COPY . /var/www/localhost/htdocs

# Allow running as non-root
RUN adduser -D user
USER user
WORKDIR /home/user

# Set out port
ARG PORT=8080
EXPOSE "${PORT}"
RUN cp -a /etc/lighttpd/lighttpd.conf lighttpd.conf 2>/dev/null && \
    echo "server.port = ${PORT}" >> lighttpd.conf

# Modify config to allow non-root usage
RUN sed -i 's|^server\.pid-file .*$|server.pidfile = "/tmp/lighttpd.pid"|' lighttpd.conf && \
    sed -i 's|^var\.logdir .*$|var.logdir = "/tmp/logs"|' lighttpd.conf && \
    mkdir -m 777 /tmp/logs

ENTRYPOINT ["lighttpd"]
CMD ["-D", "-f", "lighttpd.conf"]
