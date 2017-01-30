function! switcharoo#Switch(cmd)
  let current_file = @%
  let switched_file = s:SwitchCoffeeFile(current_file)

  if filereadable(switched_file)
    execute a:cmd . " " . switched_file
  else
    let found_file = findfile(switched_file, "**/.")
    if filereadable(found_file)
      execute a:cmd . " " . found_file
    else
      echohl WarningMsg
      echomsg "yo" . found_file
      echohl None
      echo ""
      let v:warningmsg = found_file
      "call s:warn("Unable to find expected alternate '".current_file."'")
    endif
  endif
endfunction

function! s:warn(str)
  echohl WarningMsg
  echomsg a:str
  echohl None
  " Sometimes required to flush output
  echo ""
  let v:warningmsg = a:str
endfunction

function! s:Sub(str,pat,rep)
  return substitute(a:str,'\v\C'.a:pat,a:rep,'')
endfunction

if !exists('g:test_directory')
  let g:test_directory = 'test'
endif

if !exists('g:src_directory')
  let g:src_directory = 'app/scripts'
endif

function! switcharoo#SwitchToJavascript()
  let current_file = @%

  if s:isSource(current_file)
    let js_filename = s:SourceToJavascript(current_file)
  endif

  if s:isTest(current_file)
    let js_filename = s:TestToJavascript(current_file)
  endif

  if filereadable(js_filename)
    execute "e " . js_filename
  endif
endfunction

function! s:SwitchCoffeeFile(current_file)
  if s:isSource(a:current_file)
    return s:toTestFile(a:current_file)
  endif

  if s:isTest(a:current_file)
    return s:toSourceFile(a:current_file)
  endif

  if s:isJavascript(a:current_file)
    return s:JavascriptToSource(a:current_file)
  endif

  return " "
endfunction

function! s:toTestFile(file)
  return substitute(a:file, "app/scripts", g:test_directory, '')
endfunction

function! s:toSourceFile(file)
  return substitute(a:file, g:test_directory, "app/scripts", '')
endfunction

function! s:JavascriptToSource(file)
  let tmp_filename = substitute(a:file, ".tmp", "app", '')
  return substitute(tmp_filename, ".js", ".coffee", '')
endfunction

function! s:SourceToJavascript(file)
  let tmp_filename = substitute(a:file, "app", ".tmp", '')
  return substitute(tmp_filename, ".coffee", ".js", '')
endfunction

function! s:TestToJavascript(file)
  let new_filename = substitute(a:file, "test", ".tmp/scripts", '')
  return substitute(new_filename, ".coffee", ".js", '')
endfunction

function! s:isTest(filename)
  if s:isCoffeeTest(a:filename)
    return 1
  else
    return 0
  endif
endfunction

function! s:isCoffeeTest(filename)
  return a:filename =~ "^". g:test_directory . "/" || a:filename =~ "/" . g:test_directory
endfunction

function! s:isSource(filename)
  if s:isCoffeeSource(a:filename)
    return 1
  else
    return 0
  endif
endfunction

function! s:isCoffeeSource(filename)
  return a:filename =~ "^app/" || a:filename =~ "/app"
endfunction

function! s:isJavascript(filename)
  if a:filename =~ "^.tmp/" || a:filename =~ "/.tmp"
    return 1
  else
    return 0
  endif
endfunction
