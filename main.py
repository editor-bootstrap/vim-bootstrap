#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
from bottle import Bottle, view
from bottle import TEMPLATE_PATH as T


PROJECT_PATH = os.path.join(os.path.abspath(os.path.dirname(__file__)))
TEMPLATE_PATH = os.path.join(PROJECT_PATH, 'views')
STATIC_PATH = os.path.join(PROJECT_PATH, 'assets')

T.insert(0, TEMPLATE_PATH)

app = Bottle()


# Note: We don't need to call run() since our application is embedded within
# the App Engine WSGI application server.


@app.route('/')
@view('index.html')
def hello():
    return {'hello': 'Thiago Avelino'}


# Define an handler for 404 errors.
@app.error(404)
def error_404(error):
    """Return a custom 404 error."""
    return 'Sorry, nothing at this URL.'
