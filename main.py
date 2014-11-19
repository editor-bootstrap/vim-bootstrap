# -*- coding: utf-8 -*-
import os
import json
import requests
import jinja2
from google.appengine.api import memcache
from jinja2 import Template
from bottle import Bottle, request, response, static_file
from bottle import TEMPLATE_PATH as T


PROJECT_PATH = os.path.join(os.path.abspath(os.path.dirname(__file__)))
TEMPLATE_PATH = os.path.join(PROJECT_PATH, 'templates')
JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(TEMPLATE_PATH),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)
STATIC_PATH = os.path.join(PROJECT_PATH, 'assets')

T.insert(0, TEMPLATE_PATH)

app = Bottle()


@app.route('/')
def index():

    def file_exist(file):
        return os.path.isfile("{}/images/logo/{}.png".format(
            STATIC_PATH, file))

    langs = memcache.get('langs')
    if not langs:
        langs = os.listdir("./vim_template/langs")
        memcache.add('langs', langs, 3600)

    template = JINJA_ENVIRONMENT.get_template('index.html')
    return template.render({'langs': langs, 'file_exist': file_exist})


@app.route('/generate.vim', method='POST')
def generate():
    url = "https://raw.githubusercontent.com/avelino/vim-bootstrap/master/"

    editor = request.POST.get("editor", "vim")
    langs = {"bundle": {}, "vim": {}, "editor": editor}
    for l in request.POST.getall('langs'):

        data = memcache.get('vim-{}'.format(l))
        if not data:
            langs["bundle"][l] = requests.get(
                "{0}vim_template/langs/{1}/{1}.bundle".format(url, l)).text
            langs["vim"][l] = requests.get(
                "{0}vim_template/langs/{1}/{1}.vim".format(url, l)).text
            memcache.add('vim-{}'.format(l),
                         {'vim': langs['vim'][l],
                          'bundle': langs['bundle'][l]}, 3600)
        else:
            langs["bundle"][l] = data['bundle']
            langs["vim"][l] = data['vim']


    template = Template(requests.get("{}vim_template/vimrc".format(url)).text)

    response.headers['Content-Type'] = 'application/text'
    response.headers['Content-Disposition'] = 'attachment; \
            filename=.{}rc'.format(editor)
    return template.render(**langs)


@app.route('/robots.txt')
def serve_robots():
    return static_file('robots.txt', root=STATIC_PATH)
    

@app.route('/assets/<path:path>', name='assets')
def static(path):
    yield static_file(path, root=STATIC_PATH)


@app.error(404)
def error_404(error):
    """Return a custom 404 error."""
    return 'Sorry, nothing at this URL.'
