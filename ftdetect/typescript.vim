fun! s:SelectTypeScript()
  if getline(1) =~# '^#!.*/bin/\%(env\s\+\)\?ts-node\>'
    set ft=typescript
  endif
endfun

autocmd BufNewFile,BufRead *.ts set filetype=typescript
autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact
autocmd BufNewFile,BufRead * call s:SelectTypeScript()
