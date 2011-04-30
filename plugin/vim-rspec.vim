"
" Vim Rspec
" Last change: March 5 2009
" Version> 0.0.5
" Maintainer: Eustáquio 'TaQ' Rangel
" License: GPL
" URL: git://github.com/taq/vim-rspec
"
" Script to run the spec command inside Vim
" To install, unpack the files on your ~/.vim directory and source it 
"
" The following options can be set/overridden in your .vimrc
"   * g:RspecXSLPath     :: Path to xsl file
"   * g:RspecRBFilePath  :: Path to vim-rspec.rb
"   * g:RspecBin         :: Rspec binary command (in rspec 2 this is 'rspec')
"   * g:RspecOpts        :: Opts to send to rspec call

let s:xsltproc_cmd	= ""
let s:grep_cmd			= ""
let s:hpricot_cmd		= ""
let s:xslt				= 0
let s:hpricot			= 0
let s:helper_dir = expand("<sfile>:h")

function! s:find_xslt()
	return system("xsltproc --version | head -n1")
endfunction

function! s:find_grep()
	return system("grep --version | head -n1")
endfunction

function! s:find_hpricot()
	return system("gem search -i hpricot")
endfunction

function! s:error_msg(msg)
	echohl ErrorMsg
	echo a:msg
	echohl None
endfunction

function! s:notice_msg(msg)
	echohl MoreMsg
	echo a:msg
	echohl None
endfunction

function! s:fetch(varname, default)
  if exists("g:".a:varname)
    return eval("g:".a:varname)
  else
    return a:default
  endif
endfunction

function! s:RunSpecMain(type)
	if len(s:xsltproc_cmd)<1
		let s:xsltproc_cmd = s:find_xslt()
		let s:xslt  = match(s:xsltproc_cmd,'\d')>=0
	end		
	if len(s:hpricot_cmd)<1
		let s:hpricot_cmd = s:find_hpricot()
		let s:hpricot = match(s:hpricot_cmd,'true')>=0
	end
	if !s:hpricot && !s:xslt 
		call s:error_msg("You need the hpricot gem or xsltproc to run this script.")
		return
	end
	if len(s:grep_cmd)<1
		let s:grep_cmd = s:find_grep()
		if match(s:grep_cmd,'\d')<0
			call s:error_msg("You need grep to run this script.")
			return
		end
	end		
	let l:bufn = bufname("%")

   " find the installed rspec command
   let l:default_cmd = ""
   if executable("spec")==1
      let l:default_cmd = "spec"
   elseif executable("rspec")==1
      let l:default_cmd = "rspec"
   end

	" filters
	let l:xsl   = s:fetch("RspecXSLPath", s:helper_dir."/vim-rspec.xsl")
	let l:rubys = s:fetch("RspecRBPath", s:helper_dir."/vim-rspec.rb")

	" hpricot gets the priority
	let l:type		= s:hpricot ? "hpricot" : "xsltproc"
	let l:filter	= s:hpricot ? "ruby ".l:rubys : "xsltproc --novalid --html ".l:xsl." - "

	" run just the current file
	if a:type=="file"
		if match(l:bufn,'_spec.rb')>=0
			call s:notice_msg("Running spec on the current file with ".l:type." ...")
      let l:spec_bin = s:fetch("RspecBin",l:default_cmd)
      let l:spec_opts = s:fetch("RspecOpts", "")
      let l:spec = l:spec_bin . " " . l:spec_opts . " -f h " . l:bufn
		else
			call s:error_msg("Seems ".l:bufn." is not a *_spec.rb file")
			return
		end			
	else
		let l:dir = expand("%:p:h")
		if isdirectory(l:dir."/spec")>0
			call s:notice_msg("Running spec on the spec directory with ".l:type." ...")
		else
			" try to find a spec directory on the current path
			let l:tokens = split(l:dir,"/")
			let l:dir = ""
			for l:item in l:tokens
				call remove(l:tokens,-1)
				let l:path = "/".join(l:tokens,"/")."/spec"
				if isdirectory(l:path)
					let l:dir = l:path
					break
				end
			endfor
			if len(l:dir)>0
				call s:notice_msg("Running spec with ".l:type." on the spec directory found (".l:dir.") ...")
			else
				call s:error_msg("No ".l:dir."/spec directory found")
				return
			end				
		end			
		if isdirectory(l:dir)<0
			call s:error_msg("Could not find the ".l:dir." directory.")
			return
		end
    let l:spec = s:fetch("RspecBin", "spec") . s:fetch("RspecOpts", "")
    let l:spec = l:spec . " -f h " . l:dir . " -p **/*_spec.rb"
	end		

	" run the spec command
	let s:cmd	= l:spec." | ".l:filter." 2> /dev/null | grep \"^[-\+\[\\#\\* ]\""
	echo

	" put the result on a new buffer
	silent exec "new" 
	setl buftype=nofile
	silent exec "r! ".s:cmd
	setl syntax=vim-rspec
	silent exec "nnoremap <buffer> <cr> :call <SID>TryToOpen()<cr>"
	silent exec "nnoremap <buffer> q :q<CR>"
	setl foldmethod=expr
	setl foldexpr=getline(v:lnum)=~'^\+'
	setl foldtext=\"+--\ \".string(v:foldend-v:foldstart+1).\"\ passed\ \"
	call cursor(1,1)	
endfunction

function! s:TryToOpen()
	let l:line = getline(".")
	if match(l:line,'^  [\/\.]')<0
		call s:error_msg("No file found.")
		return
	end
	let l:tokens = split(l:line,":")
	silent exec "sp ".substitute(l:tokens[0],'/^\s\+',"","")
	call cursor(l:tokens[1],1)
endfunction

function! RunSpec()
	call s:RunSpecMain("file")
endfunction

function! RunSpecs()
	call s:RunSpecMain("dir")
endfunction

command! RunSpec	call RunSpec()
command! RunSpecs	call RunSpecs()
