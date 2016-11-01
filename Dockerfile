FROM golang:latest
MAINTAINER Avelino <thiago@avelino.xxx>

RUN mkdir /usr/local/go/src/github.com/avelino/vim-bootstrap -p
ADD . /usr/local/go/src/github.com/avelino/vim-bootstrap

WORKDIR /usr/local/go/src/github.com/avelino/vim-bootstrap

RUN curl https://glide.sh/get | sh && glide up
RUN go build

CMD ["/usr/local/go/src/github.com/avelino/vim-bootstrap/vim-bootstrap", "-server"]
