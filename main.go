package main

import (
	"flag"
	"fmt"
	"net/http"
	"os"
	"strings"

	"github.com/avelino/vim-bootstrap/generate"
	"github.com/avelino/vim-bootstrap/web"
	"github.com/gorilla/mux"
	"github.com/urfave/negroni"
)

func main() {
	langs := flag.String("langs", "", "Set languages used: go,python,c")
	frameworks := flag.String("frameworks", "", "Set frameworks used: vue,react,django")
	editor := flag.String("editor", "vim", "Set editor: vim or nvim")
	server := flag.Bool("server", false, "Up http server")
	flag.Parse()
	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	if *server {
		n := negroni.Classic()
		r := mux.NewRouter()
		r.HandleFunc("/", web.HandleHome).Methods("GET")
		r.HandleFunc("/generate.vim", web.HandleGenerate).Methods("POST")
		r.HandleFunc("/langs", web.HandleLangs)
		r.HandleFunc("/frameworks", web.HandleFrameworks)
		r.HandleFunc("/hook", web.HandleHook).Methods("POST")
		r.PathPrefix("/assets").Handler(
			http.StripPrefix("/assets", http.FileServer(http.Dir("./template/assets/"))))

		n.UseHandler(r)
		n.Run(fmt.Sprintf(":%s", port))
	}

	obj := generate.Object{
		Frameworks: strings.Split(*frameworks, ","),
		Language:   strings.Split(*langs, ","),
		Editor:     *editor,
		Version:    web.HashCommit(),
	}
	gen := generate.Generate(&obj)
	fmt.Println(gen)
}
