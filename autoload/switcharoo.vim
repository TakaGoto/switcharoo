function! v:SwitchRubyFile(cmd, current_file)
  let new_filename = s:ToggleFilename(current_file)

  if filereadable(new_filename)
    return new_filename
  else
    let found_file = findfile(v:ToggleTail(expand('%:t')), "**/.")
    if filereadable(found_file)
      execute a:cmd . " " . found_file
    else
      call s:warn("Unable to find expected alternate '".new_filename."'")
    endif
  endif
endfunction

function! s:ToggleFilename(filename)
  if a:filename =~ "^lib/" || a:filename =~ "/lib/"
    if v:isTest(a:filename)
      return v:ToggleTail(s:Sub(s:Sub(a:filename, "^spec/", ""), "/spec/", "/"))
    else
      return v:ToggleTail(s:Sub(s:Sub(a:filename, "/lib/", "/spec/lib/"), "^lib/", "spec/lib/"))
    endif
  else
    if v:isTest(a:filename)
      return v:ToggleTail(s:Sub(s:Sub(a:filename, "^spec/", "app/"), "/spec/", "/app/"))
    else
      return v:ToggleTail(s:Sub(s:Sub(a:filename, "^app/", "spec/"), "/app/", "/spec/"))
    endif
  endif
endfunction

function! s:Sub(str,pat,rep)
  return substitute(a:str,'\v\C'.a:pat,a:rep,'')
endfunction

function! v:ToggleTail(filename)
  if v:isTest(a:filename)
    return s:Sub(a:filename, "_spec\.rb$", ".rb")
  else
    return s:Sub(a:filename, "\.rb$", "_spec.rb")
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

if !exists('g:test_directory')
  let g:test_directory = 'test'
endif

if !exists('g:src_directory')
  let g:src_directory = 'app/scripts'
endif

function! switcharoo#Switch(cmd)
  let current_file = @%

  if v:isRuby(current_file)
    let switched_file = v:SwitchRubyFile(a:cmd, current_file)
  else
    let switched_file = v:SwitchCoffeeFile(current_file)
  endif

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
  if v:isCoffeeTest(a:filename) || v:isRubyTest(a:filename)
    return 1
  else
    return 0
  endif
endfunction

function! v:isRubyTest(filename)
  return a:filename =~ "_spec\.rb$"
endfunction

function! v:isCoffeeTest(filename)
  return a:filename =~ "^". g:test_directory . "/" || a:filename =~ "/" . g:test_directory
endfunction

function! v:isSource(filename)
  if v:isCoffeeSource(a:filename) || v:isRubySource(a:filename)
    return 1
  else
    return 0
  endif
endfunction

function! v:isCoffeeSource(filename)
  return a:filename =~ "^app/" || a:filename =~ "/app"
endfunction

function! v:isRubySource(filename)
  return a:filename =~ "^lib/" || a:filename =~ "/lib"
endfunction

function! v:isJavascript(filename)
  if a:filename =~ "^.tmp/" || a:filename =~ "/.tmp"
    return 1
  else
    return 0
  endif
endfunction

function! v:isRuby(filename)
  if a:filename =~ ".rb"
    return 1
  else
    return 0
  endif
endfunction
