function! switcharoo#Switch(cmd)
  let current_file = @%
  let switched_file = v:SwitchFile(current_file)

  if filereadable(switched_file)
    execute a:cmd . " " . switched_file
  end
endfunction

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

function! v:SwitchFile(current_file)
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
  return substitute(a:file, "app/scripts", "test", '')
endfunction

function! v:toSourceFile(file)
  return substitute(a:file, "test", "app/scripts", '')
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
  if a:filename =~ "^test/" || a:filename =~ "/test"
    return 1
  else
    return 0
  endif
endfunction

function! v:isSource(filename)
  if a:filename =~ "^app/" || a:filename =~ "/app"
    return 1
  else
    return 0
  endif
endfunction

function! v:isJavascript(filename)
  if a:filename =~ "^.tmp/" || a:filename =~ "/.tmp"
    return 1
  else
    return 0
  endif
endfunction