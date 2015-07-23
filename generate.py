# -*- coding: utf-8 -*-
import os
import sys
import jinja2
from jinja2 import Template


PROJECT_PATH = os.path.join(os.path.abspath(os.path.dirname(__file__)))
TEMPLATE_PATH = os.path.join(PROJECT_PATH, 'templates')
JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(TEMPLATE_PATH),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)


def generate():
    selected_langs = sys.argv[1:]

    if not selected_langs:
        print 'You forgot to specify the languages you want!'
        sys.exit(1)

    langs = {"bundle": {}, "vim": {}, "editor": 'vim'}

    for l in selected_langs:
        for ext in ["bundle", "vim"]:
            with open("./vim_template/langs/{0}/{0}.{1}".format(l, ext)) as f:
                langs[ext][l] = f.read()

    template = None
    with open("./vim_template/vimrc") as f:
        template = Template(f.read().decode('utf-8'))

    if not template:
        template = Template("")

    langs['select_lang'] = ",".join(selected_langs)
    print template.render(**langs).encode('utf-8')


if __name__ == '__main__':
    generate()
