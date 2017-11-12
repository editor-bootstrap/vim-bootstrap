FROM golang:alpine
LABEL mantainer="thiago@avelino.xxx"
LABEL mantainer="cassiobotaro@gmail.com"

RUN apk --no-cache add git
WORKDIR /go/src/github.com/avelino/vim-bootstrap
COPY . /go/src/github.com/avelino/vim-bootstrap

# Go dep!
RUN go get -u github.com/golang/dep/...
RUN dep ensure

RUN go install
CMD ["vim-bootstrap", "-server"]
