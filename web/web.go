package web

import (
	"io/ioutil"
	"net/http"
	"os/exec"
	"strings"
	"text/template"

	"github.com/avelino/vim-bootstrap/generate"
)

const (
	emtyStr  = ""
	git      = "git"
	checkout = "checkout"
	force    = "-f"
	pull     = "pull"
)

func listLangs() (list []string) {
	// List all languages on folder
	files, _ := ioutil.ReadDir("./vim_template/langs")
	for _, f := range files {
		list = append(list, f.Name())
	}
	return
}

func HandleHook(w http.ResponseWriter, r *http.Request) {
	// Update repo
	exec.Command(git, checkout, force).Output()
	exec.Command(git, pull).Output()

	w.Write([]byte("Done!\n"))
}

func HandleHome(w http.ResponseWriter, r *http.Request) {
	Body := make(map[string]interface{})
	Body["Langs"] = listLangs()

	t := template.Must(template.ParseFiles("./template/index.html"))
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

func HandleLangs(w http.ResponseWriter, r *http.Request) {
	langs := strings.Join(listLangs(), ",")
	w.Write([]byte(langs))
}
