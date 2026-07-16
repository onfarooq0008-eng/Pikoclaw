FROM golang:1.25-alpine AS builder

WORKDIR /build

RUN apk add --no-cache git

RUN git clone https://github.com/sipeed/picoclaw.git .

RUN go build -o picoclaw .
RUN go build -o picoclaw-launcher ./cmd/picoclaw-launcher


FROM alpine:latest

WORKDIR /app

COPY --from=builder /build/picoclaw /usr/local/bin/picoclaw
COPY --from=builder /build/picoclaw-launcher /usr/local/bin/picoclaw-launcher

RUN mkdir -p /root/.picoclaw/workspace

ENV PICOCLAW_GATEWAY_HOST=0.0.0.0
ENV PICOCLAW_LAUNCHER_TOKEN=admin

EXPOSE 18800
EXPOSE 18790

CMD sh -c "picoclaw-launcher -public & picoclaw gateway"
