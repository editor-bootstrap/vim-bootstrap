package web

import (
	"encoding/json"
	"html/template"
	"net/http"
	"strings"
	"time"

	"github.com/editor-bootstrap/vim-bootstrap/generate"
)

// HashCommit returns timestamp
func HashCommit() string {
	t := time.Now()
	// yearmonthdayhourminutesseconds
	return t.Format("2006-01-02 15:04:05")
}

// HandleHome is a handler to expose main page configurations
func HandleHome(w http.ResponseWriter, r *http.Request) {
	Body := make(map[string]interface{})
	Body["Langs"] = generate.ListLangs()
	Body["Frameworks"] = generate.ListFrameworks()
	Body["Themes"] = generate.ListThemes()
	Body["PluginCategories"] = generate.ListPluginCategories()
	Body["Version"] = HashCommit()

	t := template.Must(template.ParseFiles("./template/index.html"))
	t.Execute(w, Body)
}

// HandleGenerate receives a post request with configurations and returns a config file.
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
	additionalPlugins := r.Form["additional_plugins"]
	obj := generate.Object{
		Frameworks:        frameworks,
		Language:          langs,
		AdditionalPlugins: additionalPlugins,
		Editor:            editor,
		Theme:             theme,
		Version:           HashCommit(),
	}
	gen := generate.Generate(&obj)

	w.Write([]byte(gen))
	return
}

// HandleThemes is an endpoint to list availables frameworks
func HandleThemes(w http.ResponseWriter, r *http.Request) {
	handleList(w, generate.ListThemes)
}

// HandleFrameworks is an endpoint to list availables frameworks
func HandleFrameworks(w http.ResponseWriter, r *http.Request) {
	handleList(w, generate.ListFrameworks)
}

// HandleLangs is an endpoint to list availables frameworks
func HandleLangs(w http.ResponseWriter, r *http.Request) {
	handleList(w, generate.ListLangs)
}

func handleList(w http.ResponseWriter, function func() []string) {
	langs := strings.Join(function(), ",")
	_, err := w.Write([]byte(langs))
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

// HandlePlugins is an endpoint to list available plugins
func HandlePlugins(w http.ResponseWriter, r *http.Request) {
	plugins := generate.ListPlugins()
	jsonData, err := json.Marshal(plugins)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write(jsonData)
}

// HandlePluginCategories is an endpoint to list available plugin categories
func HandlePluginCategories(w http.ResponseWriter, r *http.Request) {
	categories := generate.ListPluginCategories()
	jsonData, err := json.Marshal(categories)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Write(jsonData)
}

// HandleValidatePlugins validates a list of selected plugins
func HandleValidatePlugins(w http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	r.ParseForm()
	selectedPlugins := r.Form["plugins"]

	warnings, errors, err := generate.ValidatePluginSelection(selectedPlugins)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	response := map[string]interface{}{
		"warnings": warnings,
		"errors":   errors,
		"valid":    len(errors) == 0,
	}

	jsonData, err := json.Marshal(response)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(jsonData)
}

// HandleFavicon just serve favicon.ico
func HandleFavicon(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "./template/assets/favicon.ico")
	// http.FileServer(http.Dir("./template/assets/"))
}
