FROM golang:alpine as builder
RUN apk add --no-cache git
WORKDIR /vim-bootstrap
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY ./ /vim-bootstrap
RUN go install -ldflags "-w -s" ./...

FROM alpine:3.9
LABEL mantainer="avelinorun@gmail.com"
LABEL mantainer="cassiobotaro@gmail.com"
RUN apk add --no-cache ca-certificates git
WORKDIR /vim-bootstrap/
COPY --from=builder /go/bin/vim-bootstrap vim-bootstrap
COPY --from=builder /go/bin/vim-bootstrap-server vim-bootstrap-server
COPY ./template template
CMD ["./vim-bootstrap-server"]
