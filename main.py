# -*- coding: utf-8 -*-
import json
import requests
from webapp2 import WSGIApplication, RequestHandler, cached_property
from webapp2_extras import jinja2
from jinja2 import Template


def dbg():
    """ Enter pdb in App Engine

    Renable system streams for it.
    """
    import pdb
    import sys
    pdb.Pdb(
        stdin=getattr(sys, '__stdin__'),
        stdout=getattr(sys, '__stderr__')).set_trace(sys._getframe().f_back)


class BaseHandler(RequestHandler):

    @cached_property
    def jinja2(self):
        return jinja2.get_jinja2(app=self.app)

    def render_response(self, _template, **context):
        rv = self.jinja2.render_template(_template, **context)
        self.response.write(rv)


class MainHandler(BaseHandler):
    def get(self):
        def file_exist(file):
            return "/assets/images/logo/{}.png".format(file)

        url = "https://api.github.com/repos/avelino/vim-bootstrap/contents"
        url += "/vim_template/langs"
        langs = [g["name"] for g in json.loads(requests.get(url).text)]

        context = {'langs': langs, 'file_exist': file_exist}
        self.render_response('index.html', **context)


class GenerateHandler(BaseHandler):

    def post(self):
        url = "https://raw.githubusercontent.com/avelino/vim-bootstrap/master/"

        langs = {"bundle": {}, "vim": {}}
        print self.request.POST.getall('langs')
        for l in self.request.POST.getall('langs'):
            langs["bundle"][l] = requests.get(
                "{0}vim_template/langs/{1}/{1}.bundle".format(url, l)).text
            langs["vim"][l] = requests.get(
                "{0}vim_template/langs/{1}/{1}.vim".format(url, l)).text

        template = Template(
            requests.get("{}vim_template/vimrc".format(url)).text)

        self.response.headers['Content-Type'] = 'application/text'
        self.response.headers['Content-Disposition'] = "attachment; "
        self.response.headers['Content-Disposition'] += "filename=.vimrc"
        self.response.out.write(template.render(**langs))


app = WSGIApplication([
    ('/', MainHandler),
    ('/generate.vim', GenerateHandler)
], debug=True)
