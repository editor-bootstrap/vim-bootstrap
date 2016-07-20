# -*- coding: utf-8 -*-
import os


class BaseEditor(object):
    def __init__(self, name):
        self.name = name

    def __str__(self):
        return self.name


class VimEditor(BaseEditor):
    @property
    def basedir(self):
        return "~/.{0.name}".format(self)

    @property
    def rc(self):
        return "~/.{0.name}rc".format(self)

    @property
    def localrc(self):
        return "{0.rc}.local".format(self)

    @property
    def localbundlerc(self):
        return "{0.rc}.local.bundles".format(self)


class NvimEditor(BaseEditor):
    @property
    def basedir(self):
        return "~/.config/{0.name}".format(self)

    @property
    def rc(self):
        return os.path.join(self.basedir, "init.vim")

    @property
    def localrc(self):
        return os.path.join(self.basedir, "local_init.vim")

    @property
    def localbundlerc(self):
        return os.path.join(self.basedir, "local_bundles.vim")


EDITORS = {
    'nvim': NvimEditor,
    'vim': VimEditor
}


def get_editor(name):
    try:
        return EDITORS[name](name)
    except KeyError:
        raise ValueError("Unknown editor '{}'".format(name))
