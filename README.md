# switcharoo

switches between Coffescript source file to Coffeescript test file and Ruby source file and spec files. the Ruby switcharoo was inspired and copied by [alt-ruby.vim](https://github.com/clembradley/alt-ruby). It can also switch to the compiled Javascript file. For now, the Coffeescript directory structure must look like below:

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
  1. [pathogen.vim](https://github.com/tpope/vim-pathogen)

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
