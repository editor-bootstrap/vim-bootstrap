" AlignMaps.vim : support functions for AlignMaps
"   Author: Charles E. Campbell, Jr.
"   Date:   Mar 03, 2009
" Version:           41
" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_AlignMaps")
 finish
endif
let g:loaded_AlignMaps= "v41"
let s:keepcpo         = &cpo
set cpo&vim

" =====================================================================
" Functions: {{{1

" ---------------------------------------------------------------------
" AlignMaps#WrapperStart: {{{2
fun! AlignMaps#WrapperStart(vis) range
"  call Dfunc("AlignMaps#WrapperStart(vis=".a:vis.")")

  if a:vis
   norm! '<ma'>
  endif

  if line("'y") == 0 || line("'z") == 0 || !exists("s:alignmaps_wrapcnt") || s:alignmaps_wrapcnt <= 0
"   call Decho("wrapper initialization")
   let s:alignmaps_wrapcnt    = 1
   let s:alignmaps_keepgd     = &gdefault
   let s:alignmaps_keepsearch = @/
   let s:alignmaps_keepch     = &ch
   let s:alignmaps_keepmy     = SaveMark("'y")
   let s:alignmaps_keepmz     = SaveMark("'z")
   let s:alignmaps_posn       = SaveWinPosn(0)
   " set up fencepost blank lines
   put =''
   norm! mz'a
   put! =''
   ky
   let s:alignmaps_zline      = line("'z")
   exe "'y,'zs/@/\177/ge"
  else
"   call Decho("embedded wrapper")
   let s:alignmaps_wrapcnt    = s:alignmaps_wrapcnt + 1
   norm! 'yjma'zk
  endif

  " change some settings to align-standard values
  set nogd
  set ch=2
  AlignPush
  norm! 'zk
"  call Dret("AlignMaps#WrapperStart : alignmaps_wrapcnt=".s:alignmaps_wrapcnt." my=".line("'y")." mz=".line("'z"))
endfun

" ---------------------------------------------------------------------
" AlignMaps#WrapperEnd:	{{{2
fun! AlignMaps#WrapperEnd() range
"  call Dfunc("AlignMaps#WrapperEnd() alignmaps_wrapcnt=".s:alignmaps_wrapcnt." my=".line("'y")." mz=".line("'z"))

  " remove trailing white space introduced by whatever in the modification zone
  'y,'zs/ \+$//e

  " restore AlignCtrl settings
  AlignPop

  let s:alignmaps_wrapcnt= s:alignmaps_wrapcnt - 1
  if s:alignmaps_wrapcnt <= 0
   " initial wrapper ending
   exe "'y,'zs/\177/@/ge"

   " if the 'z line hasn't moved, then go ahead and restore window position
   let zstationary= s:alignmaps_zline == line("'z")

   " remove fencepost blank lines.
   " restore 'a
   norm! 'yjmakdd'zdd

   " restore original 'y, 'z, and window positioning
   call RestoreMark(s:alignmaps_keepmy)
   call RestoreMark(s:alignmaps_keepmz)
   if zstationary > 0
    call RestoreWinPosn(s:alignmaps_posn)
"    call Decho("restored window positioning")
   endif

   " restoration of options
   let &gd= s:alignmaps_keepgd
   let &ch= s:alignmaps_keepch
   let @/ = s:alignmaps_keepsearch

   " remove script variables
   unlet s:alignmaps_keepch
   unlet s:alignmaps_keepsearch
   unlet s:alignmaps_keepmy
   unlet s:alignmaps_keepmz
   unlet s:alignmaps_keepgd
   unlet s:alignmaps_posn
  endif

"  call Dret("AlignMaps#WrapperEnd : alignmaps_wrapcnt=".s:alignmaps_wrapcnt." my=".line("'y")." mz=".line("'z"))
endfun

" ---------------------------------------------------------------------
" AlignMaps#StdAlign: some semi-standard align calls {{{2
fun! AlignMaps#StdAlign(mode) range
"  call Dfunc("AlignMaps#StdAlign(mode=".a:mode.")")
  if     a:mode == 1
   " align on @
"   call Decho("align on @")
   AlignCtrl mIp1P1=l @
   'a,.Align
  elseif a:mode == 2
   " align on @, retaining all initial white space on each line
"   call Decho("align on @, retaining all initial white space on each line")
   AlignCtrl mWp1P1=l @
   'a,.Align
  elseif a:mode == 3
   " like mode 2, but ignore /* */-style comments
"   call Decho("like mode 2, but ignore /* */-style comments")
   AlignCtrl v ^\s*/[/*]
   AlignCtrl mWp1P1=l @
   'a,.Align
  else
   echoerr "(AlignMaps) AlignMaps#StdAlign doesn't support mode#".a:mode
  endif
"  call Dret("AlignMaps#StdAlign")
endfun

" ---------------------------------------------------------------------
" AlignMaps#CharJoiner: joins lines which end in the given character (spaces {{{2
"             at end are ignored)
fun! AlignMaps#CharJoiner(chr)
"  call Dfunc("AlignMaps#CharJoiner(chr=".a:chr.")")
  let aline = line("'a")
  let rep   = line(".") - aline
  while rep > 0
  	norm! 'a
  	while match(getline(aline),a:chr . "\s*$") != -1 && rep >= 0
  	  " while = at end-of-line, delete it and join with next
  	  norm! 'a$
  	  j!
  	  let rep = rep - 1
  	endwhile
  	" update rep(eat) count
  	let rep = rep - 1
  	if rep <= 0
  	  " terminate loop if at end-of-block
  	  break
  	endif
  	" prepare for next line
  	norm! jma
  	let aline = line("'a")
  endwhile
"  call Dret("AlignMaps#CharJoiner")
endfun

" ---------------------------------------------------------------------
" AlignMaps#Equals: supports \t= and \T= {{{2
fun! AlignMaps#Equals() range
"  call Dfunc("AlignMaps#Equals()")
  'a,'zs/\s\+\([*/+\-%|&\~^]\==\)/ \1/e
  'a,'zs@ \+\([*/+\-%|&\~^]\)=@\1=@ge
  'a,'zs/==/\="\<Char-0x0f>\<Char-0x0f>"/ge
  'a,'zs/\([!<>:]\)=/\=submatch(1)."\<Char-0x0f>"/ge
  norm g'zk
  AlignCtrl mIp1P1=l =
  AlignCtrl g =
  'a,'z-1Align
  'a,'z-1s@\([*/+\-%|&\~^!=]\)\( \+\)=@\2\1=@ge
  'a,'z-1s/\( \+\);/;\1/ge
  if &ft == "c" || &ft == "cpp"
"   call Decho("exception for ".&ft)
   'a,'z-1v/^\s*\/[*/]/s/\/[*/]/@&@/e
   'a,'z-1v/^\s*\/[*/]/s/\*\//@&/e
   if exists("g:mapleader")
    exe "norm 'zk"
    call AlignMaps#StdAlign(1)
   else
    exe "norm 'zk"
    call AlignMaps#StdAlign(1)
   endif
   'y,'zs/^\(\s*\) @/\1/e
  endif
  'a,'z-1s/\%x0f/=/ge
  'y,'zs/ @//eg
"  call Dret("AlignMaps#Equals")
endfun

" ---------------------------------------------------------------------
" AlignMaps#Afnc: useful for splitting one-line function beginnings {{{2
"            into one line per argument format
fun! AlignMaps#Afnc()
"  call Dfunc("AlignMaps#Afnc()")

  " keep display quiet
  let chkeep = &ch
  let gdkeep = &gd
  let vekeep = &ve
  set ch=2 nogd ve=

  " will use marks y,z ; save current values
  let mykeep = SaveMark("'y")
  let mzkeep = SaveMark("'z")

  " Find beginning of function -- be careful to skip over comments
  let cmmntid  = synIDtrans(hlID("Comment"))
  let stringid = synIDtrans(hlID("String"))
  exe "norm! ]]"
  while search(")","bW") != 0
"   call Decho("line=".line(".")." col=".col("."))
   let parenid= synIDtrans(synID(line("."),col("."),1))
   if parenid != cmmntid && parenid != stringid
   	break
   endif
  endwhile
  norm! %my
  s/(\s*\(\S\)/(\r  \1/e
  exe "norm! `y%"
  s/)\s*\(\/[*/]\)/)\r\1/e
  exe "norm! `y%mz"
  'y,'zs/\s\+$//e
  'y,'zs/^\s\+//e
  'y+1,'zs/^/  /

  " insert newline after every comma only one parenthesis deep
  sil! exe "norm! `y\<right>h"
  let parens   = 1
  let cmmnt    = 0
  let cmmntline= -1
  while parens >= 1
"   call Decho("parens=".parens." @a=".@a)
   exe 'norm! ma "ay`a '
   if @a == "("
    let parens= parens + 1
   elseif @a == ")"
    let parens= parens - 1

   " comment bypass:  /* ... */  or //...
   elseif cmmnt == 0 && @a == '/'
    let cmmnt= 1
   elseif cmmnt == 1
	if @a == '/'
	 let cmmnt    = 2   " //...
	 let cmmntline= line(".")
	elseif @a == '*'
	 let cmmnt= 3   " /*...
	else
	 let cmmnt= 0
	endif
   elseif cmmnt == 2 && line(".") != cmmntline
	let cmmnt    = 0
	let cmmntline= -1
   elseif cmmnt == 3 && @a == '*'
	let cmmnt= 4
   elseif cmmnt == 4
	if @a == '/'
	 let cmmnt= 0   " ...*/
	elseif @a != '*'
	 let cmmnt= 3
	endif

   elseif @a == "," && parens == 1 && cmmnt == 0
	exe "norm! i\<CR>\<Esc>"
   endif
  endwhile
  norm! `y%mz%
  sil! 'y,'zg/^\s*$/d

  " perform substitutes to mark fields for Align
  sil! 'y+1,'zv/^\//s/^\s\+\(\S\)/  \1/e
  sil! 'y+1,'zv/^\//s/\(\S\)\s\+/\1 /eg
  sil! 'y+1,'zv/^\//s/\* \+/*/ge
  sil! 'y+1,'zv/^\//s/\w\zs\s*\*/ */ge
  "                                                 func
  "                    ws  <- declaration   ->    <-ptr  ->   <-var->    <-[array][]    ->   <-glop->      <-end->
  sil! 'y+1,'zv/^\//s/^\s*\(\(\K\k*\s*\)\+\)\s\+\([(*]*\)\s*\(\K\k*\)\s*\(\(\[.\{-}]\)*\)\s*\(.\{-}\)\=\s*\([,)]\)\s*$/  \1@#\3@\4\5@\7\8/e
  sil! 'y+1,'z+1g/^\s*\/[*/]/norm! kJ
  sil! 'y+1,'z+1s%/[*/]%@&@%ge
  sil! 'y+1,'z+1s%*/%@&%ge
  AlignCtrl mIp0P0=l @
  sil! 'y+1,'zAlign
  sil! 'y,'zs%@\(/[*/]\)@%\t\1 %e
  sil! 'y,'zs%@\*/% */%e
  sil! 'y,'zs/@\([,)]\)/\1/
  sil! 'y,'zs/@/ /
  AlignCtrl mIlrp0P0= # @
  sil! 'y+1,'zAlign
  sil! 'y+1,'zs/#/ /
  sil! 'y+1,'zs/@//
  sil! 'y+1,'zs/\(\s\+\)\([,)]\)/\2\1/e

  " Restore
  call RestoreMark(mykeep)
  call RestoreMark(mzkeep)
  let &ch= chkeep
  let &gd= gdkeep
  let &ve= vekeep

"  call Dret("AlignMaps#Afnc")
endfun

" ---------------------------------------------------------------------
"  AlignMaps#FixMultiDec: converts a   type arg,arg,arg;   line to multiple lines {{{2
fun! AlignMaps#FixMultiDec()
"  call Dfunc("AlignMaps#FixMultiDec()")

  " save register x
  let xkeep   = @x
  let curline = getline(".")
"  call Decho("curline<".curline.">")

  " Get the type.  I'm assuming one type per line (ie.  int x; double y;   on one line will not be handled properly)
  let @x=substitute(curline,'^\(\s*[a-zA-Z_ \t][a-zA-Z0-9_ \t]*\)\s\+[(*]*\h.*$','\1','')
"  call Decho("@x<".@x.">")

  " transform line
  exe 's/,/;\r'.@x.' /ge'

  "restore register x
  let @x= xkeep

"  call Dret("AlignMaps#FixMultiDec : my=".line("'y")." mz=".line("'z"))
endfun

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
