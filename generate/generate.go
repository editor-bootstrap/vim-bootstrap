package generate

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"path/filepath"
	"text/template"
)

type Config struct {
	BaseDir     string
	Rc          string
	LocalRc     string
	LocalBundle string
}

type Object struct {
	Language     []string
	BufferLang   map[string]string
	BufferBundle map[string]string
	Editor       string
	Config       *Config
	Version      string
}

var VimBuffer bytes.Buffer

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
			filePath := fmt.Sprintf("./vim_template/langs/%s/%s.%s", lang, lang, ext)
			read, _ := ioutil.ReadFile(filePath)
			if ext == "vim" {
				mLang[lang] = string(read)
			} else {
				mBundle[lang] = string(read)
			}
		}
	}
	obj.BufferLang = mLang
	obj.BufferBundle = mBundle

	t := template.Must(template.ParseFiles("./vim_template/vimrc"))
	t.Execute(&VimBuffer, obj)

	buffer = VimBuffer.String()
	return
}
