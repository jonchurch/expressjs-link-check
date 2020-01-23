FROM golang:latest

RUN apt-get update && apt-get install -y gawk

RUN go get -u github.com/raviqqe/muffet

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

