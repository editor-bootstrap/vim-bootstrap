# -*- coding: utf-8 -*-
import argparse
import os
import sys
import jinja2
from jinja2 import Template

import editors

PROJECT_PATH = os.path.join(os.path.abspath(os.path.dirname(__file__)))
TEMPLATE_PATH = os.path.join(PROJECT_PATH, 'templates')
JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(TEMPLATE_PATH),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)


def generate(editor, selected_langs):
    assert selected_langs, "No languages passed to generate"

    ctx = {"bundle": {}, "vim": {}, "editor": editor}

    for l in selected_langs:
        for ext in ["bundle", "vim"]:
            with open("./vim_template/langs/{0}/{0}.{1}".format(l, ext)) as f:
                ctx[ext][l] = f.read()

    template = None
    with open("./vim_template/vimrc") as f:
        template = Template(f.read().decode('utf-8'))

    if not template:
        template = Template("")

    ctx['select_lang'] = ",".join(selected_langs)
    def sh_exist(lang):
        return os.path.isfile("./vim_template/langs/{0}/{0}.sh".format(lang))
    ctx['sh_exist'] = sh_exist
    print template.render(**ctx).encode('utf-8')

def main():
    parser = argparse.ArgumentParser(description="Vim boostrap generator")
    parser.add_argument("editor", type=str,
                        choices=editors.EDITORS.keys(),
                        help="Editor to generate config for")
    parser.add_argument("--langs", "-l", type=str, required=True,
                        help="Comma seperated list of languages")
    args = parser.parse_args()
    editor = editors.get_editor(args.editor)
    langs = args.langs.split(',')

    generate(editor, langs)

if __name__ == '__main__':
    main()
