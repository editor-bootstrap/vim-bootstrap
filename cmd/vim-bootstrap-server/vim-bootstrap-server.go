package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/editor-bootstrap/vim-bootstrap/web"
	"github.com/gorilla/mux"
	"github.com/urfave/negroni"
)

func main() {
	n := negroni.Classic()
	r := mux.NewRouter()

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	r.HandleFunc("/", web.HandleHome).Methods("GET")
	r.HandleFunc("/favicon.ico", web.HandleFavicon)
	r.HandleFunc("/generate.vim", web.HandleGenerate).Methods("POST")
	r.HandleFunc("/langs", web.HandleLangs)
	r.HandleFunc("/frameworks", web.HandleFrameworks)
	r.HandleFunc("/themes", web.HandleThemes)
	r.PathPrefix("/assets").Handler(
		http.StripPrefix("/assets", http.FileServer(http.Dir("./template/assets/"))))
	n.UseHandler(r)
	n.Run(fmt.Sprintf(":%s", port))
}
