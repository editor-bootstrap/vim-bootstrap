# -*- coding: utf-8 -*-
import os
import json
import requests
import jinja2
from jinja2 import Template
from bottle import Bottle, request, response
from bottle import TEMPLATE_PATH as T


PROJECT_PATH = os.path.join(os.path.abspath(os.path.dirname(__file__)))
TEMPLATE_PATH = os.path.join(PROJECT_PATH, 'views')
JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(TEMPLATE_PATH),
    extensions=['jinja2.ext.autoescape'],
    autoescape=True)
STATIC_PATH = os.path.join(PROJECT_PATH, 'assets')

T.insert(0, TEMPLATE_PATH)

app = Bottle()


@app.route('/')
def index():
    template = JINJA_ENVIRONMENT.get_template('index.html')
    url = "https://api.github.com/repos/avelino/.vimrc/contents/langs"
    url += "?ref=clean"
    langs = [g["name"] for g in json.loads(requests.get(url).text)]

    return template.render({'langs': langs})


@app.route('/generate.vim', method='POST')
def generate():
    url = "https://raw.githubusercontent.com/avelino/.vimrc/clean/"

    langs = {"bundle": {}, "vim": {}}
    for l in request.POST.getall('langs'):
        langs["bundle"][l] = requests.get(
            "{0}langs/{1}/{1}.bundle".format(url, l)).text
        langs["vim"][l] = requests.get(
            "{0}langs/{1}/{1}.vim".format(url, l)).text

    template = Template(requests.get("{}vimrc".format(url)).text)

    response.headers['Content-Type'] = 'application/text'
    response.headers['Content-Disposition'] = 'attachment; filename=.vimrc'
    return template.render(**langs)


# Define an handler for 404 errors.
@app.error(404)
def error_404(error):
    """Return a custom 404 error."""
    return 'Sorry, nothing at this URL.'
