source autoload/switcharoo.vim

describe 'v:isTest'
  it 'returns false if the file is not in coffee test directory'
    Expect v:isTest("/source-file/blah.coffee") == 0
  end

  it 'returns true if the file is in a coffee test directory'
    Expect v:isTest("test/blah.coffee") == 1
  end

  it 'returns true if the file directory is in coffee test path'
    Expect v:isTest("yo/test/blah.coffee") == 1
  end

  it 'returns true if the file directory is in a ruby test path'
    Expect v:isTest("spec/hello_spec.rb") == 1
  end

  it 'returns false if the file directory is not in ruby or coffee source path'
    Expect v:isTest("blah/hello.rb") == 0
  end
end

describe 'v:isSource'
  it 'returns false if the file is not in coffee source directory'
    Expect v:isSource("/test-file/blah.coffee") == 0
  end

  it 'returns true if the file is in a coffee source directory'
    Expect v:isSource("app/blah.coffee") == 1
  end

  it 'returns true if the file directory is in coffee source path'
    Expect v:isSource("yo/app/blah.coffee") == 1
  end

  it 'returns true if the file directory is a ruby source path'
    Expect v:isSource("lib/hello/moto.rb") == 1
  end

  it 'returns false if the file directory is not a ruby or coffee source'
    Expect v:isSource("hello/moto.rb") == 0
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

describe 'v:SwitchCoffeeFile'
  it 'returns source file from test file'
    Expect v:SwitchCoffeeFile("/test/blah.coffee") == "/app/scripts/blah.coffee"
  end

  it 'returns test file from source file'
    Expect v:SwitchCoffeeFile("/app/scripts/blah.coffee") == "/test/blah.coffee"
  end

  it 'returns test file from source file under spec'
    let g:test_directory = "spec"

    Expect v:SwitchCoffeeFile("/app/scripts/blah.coffee") == "/spec/blah.coffee"
  end

  it 'returns source file from javascript file'
    Expect v:SwitchCoffeeFile(".tmp/scripts/blah.coffee") == "app/scripts/blah.coffee"
  end

  it 'returns blank if it"s not a javascript, source, or test file'
    Expect v:SwitchCoffeeFile("/randomdirectory/blah.coffee") == " "
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

describe 'v:ToggleTail'
  it 'switches *_spec.rb to .rb'
    Expect v:ToggleTail("blah_spec.rb") == "blah.rb"
  end

  it 'switches .rb to *_spec.rb'
    Expect v:ToggleTail("blah.rb") == "blah_spec.rb"
  end
end
