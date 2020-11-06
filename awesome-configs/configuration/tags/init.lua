local awful = require('awful')
local gears = require('gears')
local icons = require('theme.icons')

local tags = {
  {
    icon = icons.terminal,
    type = 'terminal',
    defaultApp = 'kitty',
  },
  {
    icon = icons.chrome,
    type = 'chrome',
    defaultApp = 'firefox',
  },
  {
    icon = icons.code,
    type = 'code',
    defaultApp = 'atom',
  },
 --[[ {
    icon = icons.social,
    type = 'social',
    defaultApp = 'station'
  },]]--
  {
    icon = icons.folder,
    type = 'files',
    defaultApp = 'nemo',
  },
  {
    icon = icons.music,
    type = 'music',
    defaultApp = 'kitty -e ncmpcpp',
  },
  {
    icon = icons.game,
    type = 'game',
    defaultApp = 'supertuxkart',
  },
  {
    icon = icons.art,
    type = 'art',
    defaultApp = 'gimp',
  },
  {
    icon = icons.vbox,
    type = 'virtualbox',
    defaultApp = 'virtualbox',
  },
  {
    icon = icons.lab,
    type = 'any',
    defaultApp = '',
  }
}

awful.layout.layouts = {
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.tile,
  awful.layout.suit.max
}


screen.connect_signal("request::desktop_decoration", function(s)
  for i, tag in pairs(tags) do
    awful.tag.add(
      i,
      {
        icon = tag.icon,
        icon_only = true,
        layout = awful.layout.suit.spiral.dwindle,
        gap_single_client = false,
        gap = 4,
        screen = s,
        defaultApp = tag.defaultApp,
        selected = i == 1
      }
    )
  end
end)


_G.tag.connect_signal(
  'property::layout',
  function(t)
    local currentLayout = awful.tag.getproperty(t, 'layout')
    if (currentLayout == awful.layout.suit.max) then
      t.gap = 0
    else
      t.gap = 4
    end
  end
)
