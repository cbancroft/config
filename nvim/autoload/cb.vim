if !exists('*cb#save_and_exec')
  function! cb#save_and_exec() abort
    :echo "Reloading Configuration"
    :silent !bombadil link -p sway
    :luafile ~/.config/nvim/init.lua
    :PackerSync
    return
  endfunction
endif


