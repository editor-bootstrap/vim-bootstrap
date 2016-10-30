package web

import (
	"io/ioutil"
	"net/http"
	"text/template"

	"github.com/avelino/vim-bootstrap/generate"
)

func HandleHome(w http.ResponseWriter, r *http.Request) {
	Body := make(map[string]interface{})
	langs := []string{}
	t := template.Must(template.ParseFiles("./templates/index.html"))

	files, _ := ioutil.ReadDir("./vim_template/langs")
	for _, f := range files {
		langs = append(langs, f.Name())
	}
	Body["Langs"] = langs

	t.Execute(w, Body)
}

func HandleGenerate(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Disposition", "attachment; filename=generate.vim")
	r.ParseForm()
	editor := r.FormValue("editor")
	langs := r.Form["langs"]
	obj := generate.Object{
		Language: langs,
		Editor:   editor,
	}
	gen := generate.Generate(&obj)

	w.Write([]byte(gen))
	return
}
