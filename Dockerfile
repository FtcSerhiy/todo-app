FROM golang:1.17-alpine3.11 AS builder

ENV GOPATH=/

COPY ./ go
WORKDIR go/

# install psql
RUN apt-get update -y && \
		apt-get -y install postgresql-client

# make wait-for-postgres.sh executable
RUN chmod +x wait-for-postgres.sh

# build go app
RUN CGO_ENABLED=0 GOOS=linux go build -o todo-app ./cmd/main.go

FROM alpine:latest

RUN apk --no-cache add ca-certificates
WORKDIR go/


CMD ["./todo-app"]
