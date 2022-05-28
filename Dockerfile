FROM alpine:edge AS builder
RUN echo https://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories; \
    apk add --no-cache mdbook

COPY book.toml /book/
COPY src /book/src
RUN mdbook build /book

FROM alpine:3.16
RUN apk add --no-cache lighttpd

COPY --from=builder /book/book /var/www/localhost/htdocs

EXPOSE 80
ENTRYPOINT ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
