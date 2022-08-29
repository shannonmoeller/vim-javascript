fun! s:SelectJavaScript()
  if getline(1) =~# '^#!.*/bin/\%(env\s\+\)\?node\>'
    set ft=javascript
  endif
endfun

autocmd BufNewFile,BufRead *.{js,jsx,mjs,cjs,jsm,es,es6},Jakefile set filetype=javascript
autocmd BufNewFile,BufRead *.jsx set filetype=javascriptreact
autocmd BufNewFile,BufRead * call s:SelectJavaScript()
