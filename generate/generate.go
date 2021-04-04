package generate

import (
	"bytes"
	"embed"
	"fmt"
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

// Theme ...
type Theme struct {
	Bundle     string
	Coloscheme string
}

// Object ...
type Object struct {
	Language        []string
	Frameworks      []string
	Theme           string
	BufferLang      map[string]string
	BufferFramework map[string]string
	BufferTheme     Theme
	BufferBundle    map[string]string
	Editor          string
	Config          *Config
	Version         string
}

//go:embed vim_template/vimrc
var vimrc string

//go:embed vim_template
var vimTemplate embed.FS

func buff(list []string, t string) (mList, mBundle map[string]string) {
	mList = make(map[string]string)
	mBundle = make(map[string]string)
	for _, name := range list {
		for _, ext := range []string{"bundle", "vim"} {
			filePath := fmt.Sprintf("vim_template/%s/%s/%s.%s", t, name, name, ext)
			read, _ := vimTemplate.ReadFile(filePath)
			if ext == "vim" {
				mList[name] = string(read)
			} else {
				mBundle[name] = string(read)
			}
		}
	}
	return
}

// ListLangs on folder langs
func ListLangs() (list []string) {
	files, _ := vimTemplate.ReadDir("vim_template/langs")
	for _, f := range files {
		list = append(list, f.Name())
	}
	return
}

// ListFrameworks on folder frameworks
func ListFrameworks() (list []string) {
	files, _ := vimTemplate.ReadDir("vim_template/frameworks")
	for _, f := range files {
		list = append(list, f.Name())
	}
	return
}

// ListThemes on folder themes
func ListThemes() (list []string) {
	files, _ := vimTemplate.ReadDir("vim_template/themes")
	for _, f := range files {
		list = append(list, f.Name())
	}
	return
}

// Generate file from configurations
func Generate(obj *Object) (buffer string) {
	config := Config{}
	switch obj.Editor {
	case "nvim", "neovim":
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

	mLang, mBundle := buff(obj.Language, "langs")
	obj.BufferLang = mLang

	mFrameworks, bundles := buff(obj.Frameworks, "frameworks")
	obj.BufferFramework = mFrameworks

	choosenThemes := []string{obj.Theme}
	mThemes, tBundles := buff(choosenThemes, "themes")
	obj.BufferTheme.Bundle = tBundles[obj.Theme]
	obj.BufferTheme.Coloscheme = mThemes[obj.Theme]

	for k, v := range bundles {
		mBundle[k] = v
	}
	obj.BufferBundle = mBundle

	var vimBuffer bytes.Buffer
	t := template.Must(template.New("vimrc").Parse(vimrc))
	t.Execute(&vimBuffer, obj)

	buffer = vimBuffer.String()
	return
}
