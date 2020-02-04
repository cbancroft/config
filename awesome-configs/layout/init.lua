local awful = require('awful')
local left_panel = require('layout.left-panel')
local top_panel = require('layout.top-panel')

-- Create a wibox for each screen and add it
_G.screen.connect_signal("request::desktop_decoration", function(s)
      -- Create the left_panel
      s.left_panel = left_panel(s)
      -- Create the Top bar
      s.top_panel = top_panel(s, true)
end)


-- Hide bars when app go fullscreen
local function updateBarsVisibility()
  for s in _G.screen do
    if s.selected_tag then
      local fullscreen = s.selected_tag.fullscreenMode
      -- Order matter here for shadow
      s.top_panel.visible = not fullscreen
      if s.left_panel then
        s.left_panel.visible = not fullscreen
      end
    end
  end
end

_G.tag.connect_signal(
  'property::selected',
  function(t)
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  'property::fullscreen',
  function(c)
    if c.first_tag then
      c.first_tag.fullscreenMode = c.fullscreen
    end
    updateBarsVisibility()
  end
)

_G.client.connect_signal(
  'unmanage',
  function(c)
    if c.fullscreen then
      c.screen.selected_tag.fullscreenMode = false
      updateBarsVisibility()
    end
  end
)
