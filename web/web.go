package web

import (
	"html/template"
	"io/ioutil"
	"net/http"
	"os/exec"
	"strings"
	"time"

	"github.com/editor-bootstrap/vim-bootstrap/generate"
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

func listThemes() (list []string) {
	// List all themes on folder
	files, _ := ioutil.ReadDir("./vim_template/themes")
	for _, f := range files {
		list = append(list, f.Name())
	}
	return
}

// HashCommit returns timestamp
func HashCommit() string {
	t := time.Now()
	// yearmonthdayhourminutesseconds
	return t.Format("2006-01-02 15:04:05")
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
	Body["Themes"] = listThemes()
	Body["Version"] = HashCommit()

	t := template.Must(template.ParseFiles("./template/index.html"))
	t.Execute(w, Body)
}

func HandleGenerate(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Disposition", "attachment; filename=generate.vim")
	r.ParseForm()
	editor := r.FormValue("editor")
	theme := r.FormValue("theme")
	if theme == "" {
		theme = "molokai"
	}
	langs := r.Form["langs"]
	frameworks := r.Form["frameworks"]
	obj := generate.Object{
		Frameworks: frameworks,
		Language:   langs,
		Editor:     editor,
		Theme:      theme,
		Version:    HashCommit(),
	}
	gen := generate.Generate(&obj)

	w.Write([]byte(gen))
	return
}

// HandleThemes is an endpoint to list availables frameworks
func HandleThemes(w http.ResponseWriter, r *http.Request) {
	handleList(w, listThemes)
}

// HandleFrameworks is an endpoint to list availables frameworks
func HandleFrameworks(w http.ResponseWriter, r *http.Request) {
	handleList(w, listFrameworks)
}

// HandleLangs is an endpoint to list availables frameworks
func HandleLangs(w http.ResponseWriter, r *http.Request) {
	handleList(w, listLangs)
}

func handleList(w http.ResponseWriter, function func() []string) {
	langs := strings.Join(function(), ",")
	_, err := w.Write([]byte(langs))
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

// HandleFavicon just serve favicon.ico
func HandleFavicon(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "./template/assets/favicon.ico")
	// http.FileServer(http.Dir("./template/assets/"))
}
