package main

import (
	"flag"
	"fmt"
	"net/http"
	"strings"

	"github.com/avelino/vim-bootstrap/generate"
	"github.com/avelino/vim-bootstrap/web"
	"github.com/codegangsta/negroni"
	"github.com/gorilla/mux"
)

func main() {
	langs := flag.String("langs", "", "an string")
	editor := flag.String("editor", "vim", "an string")
	server := flag.Bool("server", false, "a bool")
	flag.Parse()

	if *server {
		n := negroni.Classic()
		r := mux.NewRouter()
		r.HandleFunc("/", web.HandleHome).Methods("GET")
		r.HandleFunc("/generate.vim", web.HandleGenerate).Methods("POST")
		r.PathPrefix("/assets").Handler(
			http.StripPrefix("/assets", http.FileServer(http.Dir("./assets/"))))

		n.UseHandler(r)
		n.Run(":3000")
	}

	obj := generate.Object{
		Language: strings.Split(*langs, ","),
		Editor:   *editor,
	}
	gen := generate.Generate(&obj)
	fmt.Println(gen)
}
