FROM golang:1.17-alpine AS builder

COPY . /src
WORKDIR /src
ENV CGO_ENABLED 0
RUN go install -trimpath

FROM alpine:3.14

COPY --from=builder /go/bin/jirm.fly.dev /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/jirm.fly.dev"]
