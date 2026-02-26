FROM rust:alpine AS builder

RUN apk add --no-cache cargo git \
  && git clone https://github.com/mbrubeck/agate.git /usr/src/agate \
  && cargo install --path /usr/src/agate

FROM alpine:3.23.2
RUN apk add --no-cache bash sudo tini 
COPY --from=builder /usr/local/cargo/bin/agate /usr/bin/agate
COPY --from=builder /usr/src/agate/content /content

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1965
VOLUME /content
ENTRYPOINT ["/sbin/tini", "-g", "--", "/entrypoint.sh"]
