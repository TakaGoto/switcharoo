source autoload/switcharoo.vim

describe 'v:isTest'
  it 'returns false if the file is not in test directory'
    Expect v:isTest("/source-file/blah.coffee") == 0
  end

  it 'returns true if the file is in a test directory'
    Expect v:isTest("test/blah.coffee") == 1
  end

  it 'returns true if the file directory is in test path'
    Expect v:isTest("yo/test/blah.coffee") == 1
  end
end

describe 'v:isSource'
  it 'returns false if the file is not in source directory'
    Expect v:isSource("/test-file/blah.coffee") == 0
  end

  it 'returns true if the file is in a source directory'
    Expect v:isSource("app/blah.coffee") == 1
  end

  it 'returns true if the file directory is in source path'
    Expect v:isSource("yo/app/blah.coffee") == 1
  end
end

describe 'v:isJavascript'
  it 'returns false if the file is not in javascript directory'
    Expect v:isJavascript("/source-file/blah.js") == 0
  end

  it 'returns true if the file is in a javascript directory'
    Expect v:isJavascript(".tmp/scripts/blah.js") == 1
  end

  it 'returns true if the file directory is in Javascript path'
    Expect v:isJavascript("yo/.tmp/blah.js") == 1
  end
end

describe 'v:SwitchFile'
  it 'returns source file from test file'
    Expect v:SwitchFile("/test/blah.coffee") == "/app/scripts/blah.coffee"
  end

  it 'returns test file from source file'
    Expect v:SwitchFile("/app/scripts/blah.coffee") == "/test/blah.coffee"
  end

  it 'returns source file from javascript file'
    Expect v:SwitchFile(".tmp/scripts/blah.coffee") == "app/scripts/blah.coffee"
  end

  it 'returns blank if it"s not a javascript, source, or test file'
    Expect v:SwitchFile("/randomdirectory/blah.coffee") == " "
  end
end

describe 'v:TestToJavascript'
  it 'returns javascript file from test file'
    Expect v:TestToJavascript("test/hello/world.coffee") == ".tmp/scripts/hello/world.js"
  end
end

describe 'v:SourceToJavascript'
  it 'returns javascript file from source file'
    Expect v:SourceToJavascript("app/scripts/hello/world.coffee") == ".tmp/scripts/hello/world.js"
  end
end
