function! switcharoo#Switch(cmd)
  let current_file = @%
  let switched_file = v:SwitchCoffeeFile(current_file)

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

  if v:isSource(current_file)
    let js_filename = v:SourceToJavascript(current_file)
  endif

  if v:isTest(current_file)
    let js_filename = v:TestToJavascript(current_file)
  endif

  if filereadable(js_filename)
    execute "e " . js_filename
  endif
endfunction

function! v:SwitchCoffeeFile(current_file)
  if v:isSource(a:current_file)
    return v:toTestFile(a:current_file)
  endif

  if v:isTest(a:current_file)
    return v:toSourceFile(a:current_file)
  endif

  if v:isJavascript(a:current_file)
    return v:JavascriptToSource(a:current_file)
  endif

  return " "
endfunction

function! v:toTestFile(file)
  return substitute(a:file, "app/scripts", g:test_directory, '')
endfunction

function! v:toSourceFile(file)
  return substitute(a:file, g:test_directory, "app/scripts", '')
endfunction

function! v:JavascriptToSource(file)
  let tmp_filename = substitute(a:file, ".tmp", "app", '')
  return substitute(tmp_filename, ".js", ".coffee", '')
endfunction

function! v:SourceToJavascript(file)
  let tmp_filename = substitute(a:file, "app", ".tmp", '')
  return substitute(tmp_filename, ".coffee", ".js", '')
endfunction

function! v:TestToJavascript(file)
  let new_filename = substitute(a:file, "test", ".tmp/scripts", '')
  return substitute(new_filename, ".coffee", ".js", '')
endfunction

function! v:isTest(filename)
  if v:isCoffeeTest(a:filename)
    return 1
  else
    return 0
  endif
endfunction

function! v:isCoffeeTest(filename)
  return a:filename =~ "^". g:test_directory . "/" || a:filename =~ "/" . g:test_directory
endfunction

function! v:isSource(filename)
  if v:isCoffeeSource(a:filename)
    return 1
  else
    return 0
  endif
endfunction

function! v:isCoffeeSource(filename)
  return a:filename =~ "^app/" || a:filename =~ "/app"
endfunction

function! v:isJavascript(filename)
  if a:filename =~ "^.tmp/" || a:filename =~ "/.tmp"
    return 1
  else
    return 0
  endif
endfunction
