# switcharoo

switches between Coffescript source file to Coffeescript test file. It can also switch to the compiled Javascript file. For now, directory structure must look like below:

```
.tmp/
  scripts/
    hello/
      world.js
    hello.js
app/
  scripts/
    hello/
      world.coffee
    hello.coffee
test/
  hello/
    world.coffee
  hello.coffee
```

### requirements
  1. pathogen

### installation
  1. add this repo under .vim/bundle
  2. look at example usage below. add something like to your .vimrc:

```
nnoremap <leader>at :SwitchARoo<cr>
nnoremap <leader>as :SwitchARooHorizontal<cr>
nnoremap <leader>av :SwitchARooVertical<cr>
nnoremap <leader>aj :SwitchToJavascript<cr>
```

### Testing

`bundle install`

`vim-flavor test`
