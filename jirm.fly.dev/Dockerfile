FROM golang:alpine AS builder

COPY . /src
WORKDIR /src
ENV CGO_ENABLED 0
RUN go install -trimpath

FROM alpine:latest

COPY --from=builder /go/bin/jirm.fly.dev /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/jirm.fly.dev"]
