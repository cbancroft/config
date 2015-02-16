-- {{{ User libraries   
local gears = require("gears")
local awful = require("awful")

-- Wibox is no longer part of standard library
local wibox = require("wibox")

--Notification Library
local naughty = require("naughty")

-- User libraries
local vicious = require("vicious")

local scratch = require("scratch")

local beautiful = require("beautiful")

local music = require("music")
local os = os
local io = io
local math = math
local naughty = naughty
local beautiful = beautiful
local pairs = pairs
local ipairs = ipairs
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell
local tonumber = tonumber
local string = string
-- }}}

module("widgets")
init_widgets = function()
		separator = wibox.widget.imagebox()
		separator:set_image(beautiful.widget_sep)
		the_widgets = { 
				init_musicwidget(),
				init_cpuwidget(),
				init_batwidget(),
				init_memwidget(),
				init_fswidget(),
				init_netwidget(),
				init_mailwidget(),
				--   org_widget = init_orgwidget()
				init_volwidget(),
				init_clockwidget(),
		}
end

-- Function to return layout containing all the widgets
layout_widgets = function()
   local layout = wibox.layout.fixed.horizontal()
   for i = 1,#the_widgets  do
      layout:add(separator)
      if the_widgets[i].widget then
      layout:add( the_widgets[i].widget )
      end
      if the_widgets[i].icon then
      layout:add( the_widgets[i].icon ) 
      end
   end

   return layout
end
init_cpuwidget = function()
   local cpuicon = wibox.widget.imagebox()
   cpuicon:set_image(beautiful.widget_cpu)

   local cpugraph = awful.widget.graph()
   cpugraph:set_width(40):set_height(14)
   cpugraph:set_background_color( beautiful.fg_off_widget )
   cpugraph_color={type="linear", from={0,0}, to={10,0},
		   stops={{0,beautiful.fg_end_widget},{1,beautiful.fg_center_widget},{2,beautiful.fg_widget}}}
   cpugraph:set_color(cpugraph_color)
-- Register widgets
   vicious.register(cpugraph,  vicious.widgets.cpu,      "$1")

   return {widget=cpugraph,icon=cpuicon}
end

init_batwidget = function()
   ret = {}
   ret.icon = wibox.widget.imagebox()
   ret.icon:set_image(beautiful.widget_bat)
   ret.widget = wibox.widget.textbox()
   vicious.register( ret.widget, vicious.widgets.bat, "$1$2%", 61, "BAT1" )
   
   return ret
end

init_memwidget = function()
   ret = {}
   ret.icon = wibox.widget.imagebox()
   ret.icon:set_image(beautiful.widget_mem)

   ret.widget = awful.widget.progressbar()

   ret.widget:set_vertical(true):set_ticks(true)
   ret.widget:set_height(12):set_width(8):set_ticks_size(2)
   ret.widget:set_background_color(beautiful.fg_off_widget)
   ret.widget:set_color({type="linear", from={0.5,0.5}, to={100,20},
			 stops={{0,beautiful.fg_widget},{1,beautiful.fg_center_widget}, {2,beautiful.fg_end_widget}}} )
   
   vicious.register(ret.widget, vicious.widgets.mem, "$1", 13 )
   return ret
end
   
   
init_fswidget = function()
   ret = {}
   ret.icon = wibox.widget.imagebox()
   ret.icon:set_image(beautiful.widget_fs)
   local fs = {
      r = awful.widget.progressbar(),
      h = awful.widget.progressbar(),
   }



   for _,w in pairs(fs) do
      w:set_vertical(true):set_ticks(false)
      w:set_height(14):set_width(5):set_ticks_size(2)
      w:set_border_color(beautiful.border_widget)
      w:set_background_color(beautiful.fg_off_widget)
      w:set_color({type="linear", 
		   from={0,0}, 
		   to={0,14},
		   stops={
		      {0,beautiful.fg_end_widget},
		      {.75,beautiful.fg_center_widget},
		      {1,beautiful.fg_widget}
		   }
		  }
		 )
      w:buttons(awful.util.table.join(
		   awful.button({},1,function() exec("rox", false) end)
				     ))
   end

   vicious.cache(vicious.widgets.fs)
   vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}", 599)
   vicious.register(fs.h, vicious.widgets.fs, "${/home used_p}", 599)

   ret.widget = wibox.layout.fixed.horizontal()
   ret.widget:add( fs.r )
   ret.widget:add( fs.h )


   return ret
end

init_netwidget = function()
   ret = {}
   ret.widget = wibox.layout.fixed.horizontal()
   downicon = wibox.widget.imagebox()
   downicon:set_image(beautiful.widget_net)
   upicon = wibox.widget.imagebox()
   upicon:set_image(beautiful.widget_netup)

   netwidget = wibox.widget.textbox()
   -- Register widget
   vicious.register(netwidget, vicious.widgets.net, 
		    function(widget, args)
		       local down = 0
		       local up = 0
		       if (tonumber(args["{eth0 carrier}"]) == 1) then
			  up = up + args["{eth0 up_kb}"]
			  down = down + args["{eth0 down_kb}"]
		       elseif (tonumber(args["{eth1 carrier}"]) == 1) then
			  up = up + args["{eth1 up_kb}"]
			  down = down + args["{eth1 down_kb}"]
		       elseif (tonumber(args["{wlp8s0 carrier}"]) == 1) then
			  up = up + args["{wlp8s0 up_kb}"]
			  down = down + args["{wlp8s0 down_kb}"]
		       end
		       return string.format( '<span color="'
					     .. beautiful.fg_netdn_widget ..
					     '">%.1f</span> <span color="'
					     .. beautiful.fg_netup_widget ..
					     '">%.1f</span>',down, up)
		    end, 3)
   -- }}
   ret.widget:add(downicon)
   ret.widget:add(netwidget)
   ret.icon = upicon

   return ret
end
		    
init_mailwidget = function()
   local home = os.getenv("HOME")
   ret = {}
   ret.icon = wibox.widget.imagebox()
   ret.icon:set_image( beautiful.widget_mail )
   ret.widget = wibox.widget.textbox()
   vicious.register(ret.widget, vicious.widgets.mdir, "$1", 60, {home .. "/.mail/work/INBOX"} )
   ret.widget:buttons( awful.util.table.join(
			  awful.button({},1,function() exec("urxvt -T mutt -e mutt") end )))

   return ret
end

-- {{{ Music Widget
init_musicwidget = function()
   ret = {}
   ret.icon = wibox.widget.imagebox()
   ret.widget =  music.widget("{artist} - {title}",
			      "<span color=\"" .. beautiful.fg_normal .. 
				 "\">Music - {state}</span>\n Title: {title}\n " ..
				 "Artist: {artist}\n Album: {album}", 
			      { pause = beautiful.icons.pause,
				play  = beautiful.icons.play
			      })
   return ret
end

-- }}}

-- {{{ Volume Widget
init_volwidget = function()
	local ret = {}
	ret.icon = wibox.widget.imagebox()
	ret.icon:set_image(beautiful.widget_vol)
	ret.widget = wibox.layout.fixed.horizontal()
	local bar = awful.widget.progressbar()
	local txt = wibox.widget.textbox()
	bar:set_vertical(true):set_ticks(true)
	bar:set_height(12):set_width(8):set_ticks_size(2)
	bar:set_background_color(beautiful.fg_off_widget)
	bar:set_color( 
		{
			type="linear",
			from={0,0},
			to={0,12},
			stops={
					{0,beautiful.fg_end_widget},
					{.75,beautiful.fg_center_widget},
					{1,beautiful.fg_widget}
			}})
	vicious.cache(vicious.widgets.volume)
	vicious.register( bar, vicious.contrib.pulse, "$1", 2, "alsa_output.pci-0000_00_1b.0.analog-stereo")
	vicious.register( txt, vicious.contrib.pulse, "$1%", 2, "alsa_output.pci-0000_00_1b.0.analog-stereo")
    bar:buttons(awful.util.table.join(
			 awful.button({ }, 1, function () exec("pavucontrol") end),
			 awful.button({ }, 4, function () vicious.contrib.pulse.add(5, "alsa_output.pci-0000_00_1b.0.analog-stereo") end),
			 awful.button({ }, 5, function () vicious.contrib.pulse.add(-5, "alsa_output.pci-0000_00_1b.0.analog-stereo") end)
	))
	ret.widget:add(bar)
	ret.widget:add(txt)

	return ret
end
-- }}}

-- {{{ Clock Widget
init_clockwidget = function()
	local ret = {}
	ret.icon = wibox.widget.imagebox()
	ret.icon:set_image(beautiful.widget_date)
	ret.widget = awful.widget.textclock("%F %R", 30 )

	return ret
end
-- }}}

