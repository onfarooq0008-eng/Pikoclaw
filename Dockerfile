FROM golang:1.25-alpine AS builder

WORKDIR /build

RUN apk add --no-cache git

RUN git clone https://github.com/sipeed/picoclaw.git .

RUN go mod download

RUN go build -o picoclaw .


FROM alpine:latest

WORKDIR /app

COPY --from=builder /build/picoclaw /usr/local/bin/picoclaw

RUN mkdir -p /root/.picoclaw/workspace

ENV PICOCLAW_HOME=/root/.picoclaw
ENV PICOCLAW_GATEWAY_HOST=0.0.0.0
ENV PICOCLAW_GATEWAY_PORT=18790

EXPOSE 18790

CMD ["picoclaw", "gateway"]
