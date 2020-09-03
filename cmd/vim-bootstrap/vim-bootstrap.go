package main

import (
	"flag"
	"fmt"
	"strings"

	"github.com/editor-bootstrap/vim-bootstrap/generate"
	"github.com/editor-bootstrap/vim-bootstrap/web"
)

func main() {
	langs := flag.String("langs", "", "Set languages used: go,python,c")
	frameworks := flag.String("frameworks", "", "Set frameworks used: vue,react,django")
	theme := flag.String("theme", "molokai", "Set colorscheme: dracula, molokai, codedark")
	editor := flag.String("editor", "vim", "Set editor: vim or nvim")
	flag.Parse()

	obj := generate.Object{
		Frameworks: strings.Split(*frameworks, ","),
		Language:   strings.Split(*langs, ","),
		Theme:      *theme,
		Editor:     *editor,
		Version:    web.HashCommit(),
	}
	gen := generate.Generate(&obj)
	fmt.Println(gen)
}
