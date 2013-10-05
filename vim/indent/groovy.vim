" Vim indent file
" Language:		Groovy
" Maintainer:		Raphael Alla <raphael@mitija.com>
" Last Change:		2009 Jul

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" Some preliminary settings
setlocal nolisp		" Make sure lisp indenting doesn't supersede us
setlocal autoindent	" indentexpr isn't much help otherwise

setlocal indentexpr=GetGroovyIndent(v:lnum)
"setlocal indentkeys+=<:>,=elif,=except

" Only define the function once.
if exists("*GetGroovyIndent")
  finish
endif

" Come here when loading the script the first time.

let s:maxoff = 50	" maximum number of lines to look backwards for ()

function! GetGroovyIndent(lnum)

  " Search backwards for the previous non-empty line.
  let plnum = prevnonblank(v:lnum - 1)

  if plnum == 0
    " This is the first non-empty line, use zero indent.
    return 0
  endif

  " If the start of the line is in a string don't change the indent.
  if has('syntax_items')
	\ && synIDattr(synID(a:lnum, 1, 1), "name") =~ "String$"
    return -1
  endif
  "
  " If we have an open bracket and a close bracket, then we don't change
  if getline(a:lnum) =~ '{[^{}]*}' 
     return indent(plnum) 
  endif
  if  getline(a:lnum) =~ '}[^{}]*{'
     return indent(plnum) - &sw
  endif

  " When the line starts with a }, try aligning it with the matching {
  if getline(v:lnum) =~ '^\s*}\s*\(//.*\|/\*.*\)\=$'
    call cursor(v:lnum, 1)
    silent normal %
    let lnum = line('.')
    if lnum < v:lnum
      return indent(lnum)
    endif
  endif

  " If we have an open bracket, then we indent
  if getline(plnum) =~ '{[^{}]*$'
    return indent(plnum) + &sw
  endif

  " If we close a bracket, the we indent back
"  if getline(a:lnum) =~ '}[^{}]*$'
"    return indent(plnum) - &sw
"  endif


  " If the previous line is inside parenthesis, use the indent of the starting
  " line.
  " Trick: use the non-existing "dummy" variable to break out of the loop when
  " going too far back.
  call cursor(plnum, 1)
  let parlnum = searchpair('(\|{\|\[', '', ')\|}\|\]', 'nbW',
	  \ "line('.') < " . (plnum - s:maxoff) . " ? dummy :"
	  \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
	  \ . " =~ '\\(Comment\\|String\\)$'")
  if parlnum > 0
    let plindent = indent(parlnum)
    let plnumstart = parlnum
  else
    let plindent = indent(plnum)
    let plnumstart = plnum
  endif


  " When inside parenthesis: If at the first line below the parenthesis add
  " two 'shiftwidth', otherwise same as previous line.
  " i = (a
  "       + b
  "       + c)
  call cursor(a:lnum, 1)
  let p = searchpair('(\|{\|\[', '', ')\|}\|\]', 'bW',
	  \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
	  \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
	  \ . " =~ '\\(Comment\\|String\\)$'")
  if p > 0
    if p == plnum
      " When the start is inside parenthesis, only indent one 'shiftwidth'.
      let pp = searchpair('(\|{\|\[', '', ')\|}\|\]', 'bW',
	  \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
	  \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
	  \ . " =~ '\\(Comment\\|String\\)$'")
      if pp > 0
	return indent(plnum) + (exists("g:pyindent_nested_paren") ? eval(g:pyindent_nested_paren) : &sw)
      endif
      return indent(plnum) + (exists("g:pyindent_open_paren") ? eval(g:pyindent_open_paren) : (&sw * 2))
    endif
    if plnumstart == p
      return indent(plnum)
    endif
    return plindent
  endif


  " Get the line and remove a trailing comment.
  " Use syntax highlighting attributes when possible.
  let pline = getline(plnum)
  let pline_len = strlen(pline)
  if has('syntax_items')
    " If the last character in the line is a comment, do a binary search for
    " the start of the comment.  synID() is slow, a linear search would take
    " too long on a long line.
    if synIDattr(synID(plnum, pline_len, 1), "name") =~ "Comment$"
      let min = 1
      let max = pline_len
      while min < max
	let col = (min + max) / 2
	if synIDattr(synID(plnum, col, 1), "name") =~ "Comment$"
	  let max = col
	else
	  let min = col + 1
	endif
      endwhile
      let pline = strpart(pline, 0, min - 1)
    endif
  else
    let col = 0
    while col < pline_len
      if pline[col] == '#'
	let pline = strpart(pline, 0, col)
	break
      endif
      let col = col + 1
    endwhile
  endif

  " When after a () construct we probably want to go back to the start line.
  " a = (b
  "       + c)
  " here
  if parlnum > 0
    return plindent
  endif

  return -1

endfunction

" vim:sw=2
