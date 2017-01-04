package main

import (
	"flag"
	"fmt"
	"net/http"
	"strings"

	"github.com/avelino/vim-bootstrap/generate"
	"github.com/avelino/vim-bootstrap/web"
	"github.com/gorilla/mux"
	"github.com/urfave/negroni"
)

func main() {
	langs := flag.String("langs", "", "Set languages used: go,python,c")
	editor := flag.String("editor", "vim", "Set editor: vim or nvim")
	server := flag.Bool("server", false, "Up http server")
	flag.Parse()

	if *server {
		n := negroni.Classic()
		r := mux.NewRouter()
		r.HandleFunc("/", web.HandleHome).Methods("GET")
		r.HandleFunc("/generate.vim", web.HandleGenerate).Methods("POST")
		r.HandleFunc("/langs", web.HandleLangs)
		r.HandleFunc("/hook", web.HandleHook).Methods("POST")
		r.PathPrefix("/assets").Handler(
			http.StripPrefix("/assets", http.FileServer(http.Dir("./template/assets/"))))

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
