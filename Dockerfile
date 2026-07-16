FROM golang:1.25-alpine AS builder

WORKDIR /build

RUN apk add --no-cache git

RUN git clone https://github.com/sipeed/picoclaw.git .

RUN go mod download

RUN go build -o picoclaw .


FROM alpine:latest

RUN apk add --no-cache nginx

WORKDIR /app

COPY --from=builder /build/picoclaw /usr/local/bin/picoclaw

COPY web /usr/share/nginx/html

RUN mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/http.d/default.conf

RUN chmod +x /usr/local/bin/picoclaw

ENV PICOCLAW_GATEWAY_HOST=0.0.0.0
ENV PICOCLAW_GATEWAY_PORT=18790

EXPOSE 8000

CMD nginx -g 'daemon off;' & picoclaw gateway
