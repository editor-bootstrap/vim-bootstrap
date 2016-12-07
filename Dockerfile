FROM golang:latest
MAINTAINER Avelino <thiago@avelino.xxx>

RUN mkdir /usr/local/go/src/github.com/avelino/vim-bootstrap -p
ADD . /usr/local/go/src/github.com/avelino/vim-bootstrap

WORKDIR /usr/local/go/src/github.com/avelino/vim-bootstrap

RUN go get -u github.com/kardianos/govendor
RUN govendor sync

RUN go build
CMD ["/usr/local/go/src/github.com/avelino/vim-bootstrap/vim-bootstrap", "-server"]
