 #!/usr/bin/python
 # -*- coding: utf-8 -*-

import os
import sys
import jinja2
from jinja2 import Template
import argparse

PROJECT_PATH = os.path.join(os.path.abspath(os.path.dirname(__file__)))
TEMPLATE_PATH = os.path.join(PROJECT_PATH, 'templates')
JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(TEMPLATE_PATH),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)
STATIC_PATH = os.path.join(PROJECT_PATH, 'assets')

def generate_file(editor, select_langs):
    """
    Generate the vim/nvim configuration file for languages
    """

    langs = {"bundle": {}, "vim": {}, "editor": editor}

    for l in select_langs:

        cache = {}
        for ext in ["bundle", "vim"]:
            with open("./vim_template/langs/{0}/{0}.{1}".format(
                    l, ext)) as f:
                cache[ext] = langs[ext][l] = f.read()

        langs["bundle"][l] = cache['bundle']
        langs["vim"][l] = cache['vim']

    template = None
    with open("./vim_template/vimrc") as f:
        template = Template(f.read().decode('utf-8'))

    filename='.{}rc'.format(editor)

    langs['select_lang'] = ",".join(select_langs)

    return template.render(**langs).encode('utf-8')

def get_langs():
    """
    Get list of available languages
    """

    return os.listdir("./vim_template/langs")

if __name__ == "__main__":

    prog_description='Generate vim/nvim configuration file locally'

    parser = argparse.ArgumentParser(description=prog_description,
            epilog='If you are already using vim-bootstrap find the languages \
                    from previous generated file with ":let vim_bootsrap_langs"')
    parser.add_argument('-e', '--editor', dest='editor', default='vim',
                        help='editor name (default: vim)',
                        choices=['vim', 'nvim'])
    parser.add_argument('--langs', dest='langs', nargs='+',
                        help="list of languages used (default: html)",
                        choices=get_langs(), default=['html'])


    args = vars(parser.parse_args())

    print 'Generating file for editor: ' + args['editor']
    print 'Languages: ' + ','.join(args['langs'])

    local_file = '{}_local'.format(args['editor'])

    f = open(local_file, 'w+')
    f.write(generate_file(args['editor'], args['langs']))
    f.close()

    print 'File created! Copy ' + local_file + \
            ' over your $HOME/.' + args['editor'] + 'rc'
