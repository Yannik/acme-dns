FROM golang:1.9.2-alpine AS builder
LABEL maintainer="joona@kuori.org"

RUN apk add --update gcc musl-dev git

RUN go get gopkg.in/Yannik/acme-dns.v10
WORKDIR /go/src/gopkg.in/Yannik/acme-dns.v10
RUN CGO_ENABLED=1 go build

FROM alpine:latest

WORKDIR /root/
COPY --from=builder /go/src/gopkg.in/Yannik/acme-dns.v10 .
RUN mkdir -p /etc/acme-dns
RUN mkdir -p /var/lib/acme-dns
RUN rm -rf ./config.cfg
RUN apk --no-cache add ca-certificates && update-ca-certificates

VOLUME ["/etc/acme-dns", "/var/lib/acme-dns"]
ENTRYPOINT ["./acme-dns.v10"]
EXPOSE 53 80 443
