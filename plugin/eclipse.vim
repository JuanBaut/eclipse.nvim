if !has('nvim-0.5')
  echohl WarningMsg
  echom "Eclipse needs Neovim >= 0.5"
  echohl None
  finish
endif

command! Eclipse lua require("eclipse").toggle()
command! EclipseEnable lua require("eclipse").enable()
command! EclipseDisable lua require("eclipse").disable()
