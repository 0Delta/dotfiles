FROM golang:alpine as builder
LABEL maintainer "0Δ (0deltast@gmali.com)>"
WORKDIR /build
COPY . /build/
ENV GO111MODULE=on
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

WORKDIR /build
RUN go mod download
RUN go build -a -o /goapp


FROM alpine:latest as production
COPY --from=builder /goapp /goapp
CMD ["/goapp"]
