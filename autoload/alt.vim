function! alt#SwitchARoo(cmd)
  let current_file = @%

  if current_file =~ "^app/" || current_file =~ "/app"
    let test_filename = substitute(current_file, "app/scripts", "test", '')
  else
    if current_file =~ "^test/" || current_file =~ "/test"
      let test_filename = substitute(current_file, "test", "app/scripts", '')
    else
      if current_file =~ "^.tmp/" || current_file =~ "/tmp"
        let tmp_filename = substitute(current_file, ".tmp/scripts", "test", '')
        let test_filename = substitute(tmp_filename, ".js", ".coffee", '')
      else
        let test_filename = " "
      endif
    endif
  endif

  if filereadable(test_filename)
    execute a:cmd . " " . test_filename
  endif
endfunction

function! alt#SwitchToJavascript()
  let current_file = @%

  if current_file =~ "^app/" || current_file =~ "/app"
    let new_filename = substitute(current_file, "app", ".tmp", '')
    let js_filename = substitute(new_filename, ".coffee", ".js", '')
  else
    if current_file =~ "^test/" || current_file =~ "/test"
      let new_filename = substitute(current_file, "test", ".tmp/scripts", '')
      let js_filename = substitute(new_filename, ".coffee", ".js", '')
    else
      let js_filename = " "
    endif
  endif


  if filereadable(js_filename)
    execute "e " . js_filename
  endif
endfunction
