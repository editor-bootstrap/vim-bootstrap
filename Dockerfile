FROM golang:1.12-alpine as builder
RUN apk add --no-cache git
WORKDIR /vim-bootstrap
COPY go.mod .
COPY go.sum .
RUN go mod download
COPY ./ /vim-bootstrap
RUN go build -ldflags "-s -w"

FROM alpine:3.9
LABEL mantainer="thiago@avelino.xxx"
LABEL mantainer="cassiobotaro@gmail.com"
RUN apk add --no-cache ca-certificates git
WORKDIR /vim-bootstrap/
COPY --from=builder /vim-bootstrap/vim-bootstrap vimbootstrap
COPY ./template template
COPY ./vim_template/ vim_template
CMD ["./vimbootstrap", "-server"]
