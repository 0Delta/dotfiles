FROM golang:alpine as builder
LABEL maintainer "0Δ (0deltast@gmali.com)>"

ENV GO111MODULE=on
ENV CGO_ENABLED=0 GOOS=linux GOARCH=amd64

WORKDIR /build
COPY ./go.mod /build
COPY ./go.sum /build
RUN go mod download
COPY ./ /build
RUN go build -a -o /goapp

FROM alpine:latest as production
COPY --from=builder /goapp /goapp
CMD ["/goapp"]
