package web

import (
	"html/template"
	"io/ioutil"
	"log"
	"net/http"
	"os/exec"
	"strings"

	"github.com/avelino/vim-bootstrap/generate"
)

const (
	git       = "git"
	checkout  = "checkout"
	force     = "-f"
	pull      = "pull"
	submodule = "submodule"
	update    = "update"
	remote    = "--remote"
	merge     = "--merge"
	add       = "add"
	tmpl      = "template"
	commit    = "commit"
	message   = "-m \"update template \""
	push      = "push"
	origin    = "origin"
	master    = "master"
)

func listLangs() (list []string) {
	// List all languages on folder
	files, _ := ioutil.ReadDir("./vim_template/langs")
	for _, f := range files {
		list = append(list, f.Name())
	}
	return
}

func listFrameworks() (list []string) {
	// List all frameworks on folder
	files, _ := ioutil.ReadDir("./vim_template/frameworks")
	for _, f := range files {
		list = append(list, f.Name())
	}
	return
}

func HashCommit() string {
	out, err := exec.Command("git", "rev-parse", "--short", "HEAD").Output()
	if err != nil {
		log.Printf("generate: %q occurs while getting vim-bootstrap version\n", err)
	}
	return strings.TrimSpace(string(out))
}

func HandleHook(w http.ResponseWriter, r *http.Request) {
	// Update repo
	exec.Command(git, checkout, force).Output()
	exec.Command(git, pull).Output()
	exec.Command(git, submodule, update, remote, merge).Output()
	exec.Command(git, add, tmpl).Output()
	exec.Command(git, commit, message).Output()
	exec.Command(git, push, origin, master).Output()

	w.Write([]byte("Done!\n"))
}

func HandleHome(w http.ResponseWriter, r *http.Request) {
	Body := make(map[string]interface{})
	Body["Langs"] = listLangs()
	Body["Frameworks"] = listFrameworks()
	Body["Version"] = HashCommit()

	t := template.Must(template.ParseFiles("./template/index.html"))
	t.Execute(w, Body)
}

func HandleGenerate(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Disposition", "attachment; filename=generate.vim")
	r.ParseForm()
	editor := r.FormValue("editor")
	langs := r.Form["langs"]
	frameworks := r.Form["frameworks"]
	obj := generate.Object{
		Frameworks: frameworks,
		Language:   langs,
		Editor:     editor,
		Version:    HashCommit(),
	}
	gen := generate.Generate(&obj)

	w.Write([]byte(gen))
	return
}

func HandleLangs(w http.ResponseWriter, r *http.Request) {
	langs := strings.Join(listLangs(), ",")
	w.Write([]byte(langs))
}

func HandleFrameworks(w http.ResponseWriter, r *http.Request) {
	frameworks := strings.Join(listFrameworks(), ",")
	w.Write([]byte(frameworks))
}
