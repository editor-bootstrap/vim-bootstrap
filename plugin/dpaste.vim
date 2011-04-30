" dpaste.vim: Vim plugin for pasting to dpaste.com (#django's favourite paste
" bin! )
" Maintainer:   Bartek Ciszkowski <bart.ciszk@gmail.com>
" Version:      0.1
"
" Thanks To: 
"   - Paul Bissex (pbx on irc) for creating dpaste :)
"   - The creator of the LodgeIt.vim plugin, in which I blatantly steal some
"   vim specific code from.
"
" Usage:
"   :Dpaste     create a paste from the current buffer or selection.
"   
" You can also map paste to CTRL + P, just add this to your .vimrc:
" map ^P :Dpaste<CR>
" (Where ^P is entered using CTRL + V, CTRL + P in Vim)

function! s:DpasteInit()
python << EOF

import vim
import urllib2, urllib


# This mapping can be fleshed out a bit, but it's the best I could do in 5 minutes.
syntax_mapping = {
    'python':           'Python',
    'sql':              'Sql',
    'htmldjango':       'DjangoTemplate',
    'javascript':       'JScript',
    'css':              'Css',
    'xml':              'Xml',
    'ruby':             'Ruby',
    'haskell':          'Haskell',
}

syntax_reverse_mapping = {}
for key, value in syntax_reverse_mapping.iteritems():
        syntax_reverse_mapping[value] = key

def new_paste(**paste_data):
    """
    The function that does all the magic work
    """

    url = "http://dpaste.com/api/v1/"
    data = urllib.urlencode(paste_data)

    try:
        req = urllib2.Request(url)
        fd = urllib2.urlopen(req, data)
    except urllib2.URLError:
        return False

    return fd.geturl()

def make_utf8(code):
    enc = vim.eval('&fenc') or vim.eval('&enc')
    return code.decode(enc, 'ignore').encode('utf-8')

EOF
endfunction


function! s:Dpasteit(line1,line2,count,...)
call s:DpasteInit()
python << endpython

# new paste
if vim.eval('a:0') != '1':
    rng_start = int(vim.eval('a:line1')) - 1
    rng_end = int(vim.eval('a:line2'))

    if int( vim.eval('a:count') ):
        code = "\n".join(vim.current.buffer[rng_start:rng_end])
    else:
        code = "\n".join(vim.current.buffer)

    code = make_utf8(code)

    syntax = syntax_mapping.get(vim.eval('&ft'), '')

    paste_data = dict(language=syntax, content=code)

    paste_url = new_paste(**paste_data)

    if paste_url:
        print "Pasted content to %s" % (paste_url)

        vim.command('setlocal nomodified')
        vim.command('let b:dpaste_url="%s"' % paste_url)
    else:
        print "Could not connect."


endpython
endfunction

command! -range=0 -nargs=* Dpaste :call s:Dpasteit(<line1>,<line2>,<count>,<f-args>)




