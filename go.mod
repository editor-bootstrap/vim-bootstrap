module github.com/editor-bootstrap/vim-bootstrap

go 1.16

require (
	github.com/gorilla/mux v1.8.0
	github.com/urfave/negroni v1.0.0
)

// +heroku install ./cmd/...
// +heroku goVersion go1.16
