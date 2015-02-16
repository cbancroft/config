local menu = require('awful.menu')
local picturesque = require('picturesque')

local smartmenu = {}

function smartmenu.show()
   local mainmenu = { items = {
                         { '&awesome', { { "change &wallpaper", picturesque.change_image },
                                         { "restart", awesome.restart },
                                         { "quit", awesome.quit } } } },
                         theme = { width = 150 } }
	local m = menu(mainmenu)
   m:show()
end

return smartmenu
