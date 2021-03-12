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

// VimBuffer ...
var VimBuffer bytes.Buffer

//go:embed vim_template/vimrc
var vimrc string

//go:embed vim_template/langs
var langs embed.FS

//go:embed vim_template/frameworks
var frameworks embed.FS

//go:embed vim_template/themes
var themes embed.FS

func buff(list []string, t string, fs embed.FS) (mList, mBundle map[string]string) {
	mList = make(map[string]string)
	mBundle = make(map[string]string)
	for _, name := range list {
		for _, ext := range []string{"bundle", "vim"} {
			filePath := fmt.Sprintf("vim_template/%s/%s/%s.%s", t, name, name, ext)
			read, _ := fs.ReadFile(filePath)
			if ext == "vim" {
				mList[name] = string(read)
			} else {
				mBundle[name] = string(read)
			}
		}
	}
	return
}

// Generate ...
func Generate(obj *Object) (buffer string) {
	// Clean VimBuffer, not append old result
	VimBuffer.Reset()

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

	mLang, mBundle := buff(obj.Language, "langs", langs)
	obj.BufferLang = mLang

	mFrameworks, bundles := buff(obj.Frameworks, "frameworks", frameworks)
	obj.BufferFramework = mFrameworks

	choosenThemes := []string{obj.Theme}
	mThemes, tBundles := buff(choosenThemes, "themes", themes)
	obj.BufferTheme.Bundle = tBundles[obj.Theme]
	obj.BufferTheme.Coloscheme = mThemes[obj.Theme]

	for k, v := range bundles {
		mBundle[k] = v
	}
	obj.BufferBundle = mBundle

	t := template.Must(template.New("vimrc").Parse(vimrc))
	t.Execute(&VimBuffer, obj)

	buffer = VimBuffer.String()
	return
}
