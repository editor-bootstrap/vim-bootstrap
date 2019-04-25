package generate

import (
	"bytes"
	"fmt"
	"log"
	"path/filepath"
	"text/template"
)

// Config ...
type Config struct {
	BaseDir     string
	Rc          string
	LocalRc     string
	LocalBundle string
}

// Object ...
type Object struct {
	Language        []string
	Frameworks      []string
	BufferLang      map[string]string
	BufferFramework map[string]string
	BufferBundle    map[string]string
	Editor          string
	Config          *Config
	Version         string
}

// VimBuffer ...
var VimBuffer bytes.Buffer

// Generate ...
func Generate(obj *Object) (buffer string) {
	// Clean VimBuffer, not append old result
	VimBuffer.Reset()

	config := Config{}
	switch obj.Editor {
	case "nvim":
		config.BaseDir = "~/.config/nvim"
		config.Rc = filepath.Join(config.BaseDir, "init.vim")
		config.LocalRc = filepath.Join(config.BaseDir, "local_init.vim")
		config.LocalBundle = filepath.Join(config.BaseDir, "local_bundles.vim")
	default:
		config.BaseDir = "~/." + obj.Editor
		config.Rc = config.BaseDir + "rc"
		config.LocalRc = config.Rc + ".local"
		config.LocalBundle = config.Rc + ".local.bundles"
	}

	obj.Config = &config

	mLang := make(map[string]string)
	mBundle := make(map[string]string)
	for _, lang := range obj.Language {
		for _, ext := range []string{"bundle", "vim"} {
			filePath := fmt.Sprintf("vim_template/langs/%s/%s.%s", lang, lang, ext)
			read, _ := Asset(filePath)
			if ext == "vim" {
				mLang[lang] = string(read)
			} else {
				mBundle[lang] = string(read)
			}
		}
	}
	obj.BufferLang = mLang

	mFrameworks := make(map[string]string)
	for _, framework := range obj.Frameworks {
		for _, ext := range []string{"bundle", "vim"} {
			filePath := fmt.Sprintf("vim_template/frameworks/%s/%s.%s", framework, framework, ext)
			read, _ := Asset(filePath)
			if ext == "vim" {
				mFrameworks[framework] = string(read)
			} else {
				mBundle[framework] = string(read)
			}
		}
	}
	obj.BufferFramework = mFrameworks

	obj.BufferBundle = mBundle

	vimrc, err := Asset("vim_template/vimrc")
	if err != nil {
		log.Fatal(err)
	}
	t := template.Must(template.New("vimrc").Parse(string(vimrc)))
	t.Execute(&VimBuffer, obj)

	buffer = VimBuffer.String()
	return
}
