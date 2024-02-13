FROM golang:alpine as builder
LABEL maintainer "0Δ (0deltast@gmali.com)>"

ENV GO111MODULE=on
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

WORKDIR /build
RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,source=go.mod,target=go.mod \
    --mount=type=bind,source=go.sum,target=go.sum \
    go mod download -x

RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=bind,target=. \
    go build -a -o /goapp

FROM alpine:latest as production
COPY --from=builder /goapp /goapp
CMD ["/goapp"]
