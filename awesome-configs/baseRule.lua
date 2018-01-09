local awful = require("awful")
local tyrannical = require("tyrannical")

local function five_layout(c,tag)
    if type(tag) == "client" then
        c, tag = tag, c
    end

    local count = #match:clients() + 1
    if count == 2 then
        awful.layout.set(awful.layout.suit.tile,tag)
        tag.master_count = 1
        tag.master_width_factor  = 0.5
    elseif count > 2 and count < 5 then
        awful.layout.set(awful.layout.suit.tile,tag)
        tag.master_count = 1
        tag.master_width_factor = 0.6
    elseif count == 5 then
        tag.master_count = 2
        tag.master_width_factor = 0.63 -- 100 columns at 1080p 11px fonts
        --awful.client.setwfact(0.66, tag.screen.selected_tag.nmaster or 1)
    end
    return 6
end

local function fair_split_or_tile(c,tag)
    if count == 2 then
        awful.layout.set(awful.layout.suit.tile,tag)
        tag.master_count = 1
        tag.master_width_factor = 0.5
    else
        awful.layout.set(awful.layout.suit.tile,tag)
        tag.master_count = 1
        tag.master_width_factor = 0.6
    end
    return 6
end

-- }}}

tags = {} --TODO remove


tyrannical.settings.block_children_focus_stealing = true
tyrannical.settings.group_children = true

tyrannical.settings.tag.layout = awful.layout.suit.tile
tyrannical.settings.tag.master_width_factor = 0.66


tyrannical.tags = {
    {
        name = "Term",
        init        = true                                           ,
        exclusive   = true                                           ,
        --icon        = utils.tools.invertedIconPath("term.png")       ,
        screen      = {1, 2} ,
        layout      = awful.layout.suit.tile                         ,
        focus_new   = true                                           ,
        selected    = true,
--         nmaster     = 2,
--         mwfact      = 0.6,
        index       = 1,
--         max_clients = five_layout,
        class       = {
            "xterm" , "urxvt" , "aterm","URxvt","XTerm", "termite", "Termite"
        },
    } ,
    {
        name = "Internet",
        init        = true                                           ,
        exclusive   = true                                           ,
        --icon        = utils.tools.invertedIconPath("net.png")        ,
        screen      = {1,2}                          ,
        layout      = awful.layout.suit.tile                          ,
--         clone_on    = 2,
        class = {
            "Opera"         , "Firefox"        , "Rekonq"    , "Dillo"        , "Arora",
            "Chromium"      , "nightly"        , "Nightly"   , "minefield"    , "Minefield",
            "luakit", "google-chrome"
        }
    } ,
    {
        name = "Files",
        init        = true                                           ,
        exclusive   = true                                           ,
        --icon        = utils.tools.invertedIconPath("folder.png")     ,
        screen      = 1                          ,
        layout      = awful.layout.suit.tile                         ,
        exec_once   = {"nautilus"},
        no_focus_stealing_in = true,
        max_clients = fair_split_or_tile,
        class  = {
            "Thunar"        , "Konqueror"      , "Dolphin"   , "ark"          , "Nautilus",
            "filelight"
        }
    } ,
    {
        name = "Develop",
     init        = true                                              ,
        exclusive   = true                                           ,
        layout      = awful.layout.suit.tile                          ,
        screen = {1,2},
        class ={ 
            "Kate"          , "KDevelop"       , "Codeblocks", "Code::Blocks" , "DDD", "kate4",
            "jetbrains-idea", "jetbrains-clion"

        }
    } ,
    {
        name = "Edit",
        init        = false                                          ,
        exclusive   = false                                           ,
        layout      = awful.layout.suit.tile.bottom                  ,
        screen = {1,2},
        class = { 
            "KWrite"        , "GVim"           , "Emacs"     , "Code::Blocks" , "DDD", "emacs", "emacs-client"               }
    } ,
    {
        name = "Media",
        init        = false                                          ,
        exclusive   = true                                           ,
        layout      = awful.layout.suit.max                          ,
        class = { 
            "Xine"          , "xine Panel"     , "xine*"     , "MPlayer"      , "GMPlayer",
            "XMMS" }
    } ,
    {
        name = "Doc",
        init        = false                                          ,
        exclusive   = true                                           ,
        layout      = awful.layout.suit.max                          ,
        force_screen= true                                           ,
        class       = {
            "Assistant"     , "Okular"         , "Evince"    , "EPDFviewer"   , "xpdf",
            "Xpdf"          ,                                        }
    } ,


    -----------------VOLATILE TAGS-----------------------
    {
        name        = "Imaging",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = true                                           ,
        layout      = awful.layout.suit.max                          ,
        class       = {"Inkscape"      , "KolourPaint"    , "Krita"     , "Karbon"       , "Karbon14"}
    } ,
    {
        name        = "Picture",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = true                                           ,
        layout      = awful.layout.suit.max                          ,
        class       = {"Digikam"       , "F-Spot"         , "GPicView"  , "ShowPhoto"    , "KPhotoAlbum"}
    } ,
    {
        name        = "Video",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = true                                           ,
        layout      = awful.layout.suit.max                          ,
        class       = {"KDenLive"      , "Cinelerra"      , "AVIDeMux"  , "Kino"}
    } ,
    {
        name        = "Movie",
        init        = false                                          ,
        position    = 12                                             ,
        exclusive   = true                                           ,
        --icon        = utils.tools.invertedIconPath("video.png")      ,
        layout      = awful.layout.suit.max                          ,
        class       = {"VLC"}
    } ,
    {
        name        = "3D",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = true                                           ,
        layout      = awful.layout.suit.max.fullscreen               ,
        class       = {"Blender"       , "Maya"           , "K-3D"      , "KPovModeler"  , }
    } ,
    {
        name        = "Music",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = true                                           ,
        screen      = 1             ,
        force_screen= true                                           ,
        --icon        = utils.tools.invertedIconPath("media.png")      ,
        layout      = awful.layout.suit.max                          ,
        class       = {"Amarok"        , "SongBird"       , "last.fm"   ,}
    } ,
    {
        name        = "Down",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = true                                           ,
        layout      = awful.layout.suit.max                          ,
        class       = {"Transmission-qt"  , "transmission", "KGet"}
    } ,
    {
        name        = "Office",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = true                                           ,
        layout      = awful.layout.suit.max                          ,
        class       = {
            "OOWriter"      , "OOCalc"         , "OOMath"    , "OOImpress"    , "OOBase"       ,
            "SQLitebrowser" , "Silverun"       , "Workbench" , "KWord"        , "KSpread"      ,
            "KPres","Basket", "openoffice.org" , "OpenOffice.*"               ,                }
    } ,
    {
        name        = "RSS",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = true                                           ,
        --icon        = utils.tools.invertedIconPath("rss.png")        ,
        layout      = awful.layout.suit.max                          ,
        class       = {}
    } ,
    {
        name        = "Chat",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = true                                           ,
        screen      = 2 or 2 ,
        --icon        = utils.tools.invertedIconPath("chat.png")       ,
        layout      = awful.layout.suit.tile                         ,
        class       = {"Pidgin"        , "Kopete"         ,}
    } ,
    {
        name        = "Burning",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = true                                           ,
        --icon        = utils.tools.invertedIconPath("burn.png")       ,
        layout      = awful.layout.suit.tile                         ,
        class       = {"k3b"}
    } ,
    {
        name        = "Mail",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = true                                           ,
--         screen      = 2 or 1     ,
        --icon        = utils.tools.invertedIconPath("mail2.png")      ,
        layout      = awful.layout.suit.max                          ,
        class       = {"Thunderbird"   , "kmail"          , "evolution" ,}
    } ,
    {
        name        = "IRC",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = true                                           ,
        screen      = 1 ,
        init        = true                                           ,
        spawn       = "konversation"                                 ,
        --icon        = utils.tools.invertedIconPath("irc.png")        ,
        force_screen= true                                           ,
        layout      = awful.layout.suit.fair                         ,
        exec_once   = {"konversation"},
        class       = {"Konversation"  , "Botch"          , "WeeChat"   , "weechat"      , "irssi", "Franz", "franz" }
    } ,
    {
        name        = "Test",
        init        = false                                          ,
        position    = 99                                             ,
        exclusive   = false                                          ,
        screen      = {1,2}     ,
        leave_kills = true                                           ,
        persist     = true                                           ,
        --icon        = utils.tools.invertedIconPath("tools.png")      ,
        layout      = awful.layout.suit.max                          ,
        class       = {}
    } ,
    {
        name        = "Config",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = false                                          ,
        --icon        = utils.tools.invertedIconPath("tools.png")      ,
        layout      = awful.layout.suit.max                        ,
        class       = {"Systemsettings", "Kcontrol"       , "gconf-editor"}
    } ,
    {
        name        = "Game",
        init        = false                                          ,
        screen      = 1                          ,
        position    = 10                                             ,
        exclusive   = false                                          ,
        --icon        = utils.tools.invertedIconPath("game.png")       ,
        force_screen= true                                           ,
        layout      = awful.layout.suit.max                        ,
        class       = {"sauer_client"  , "Cube 2$"        , "Cube 2: Sauerbraten"        ,}
    } ,
    {
        name        = "Gimp",
        init        = false                                          ,
        position    = 10                                             ,
        exclusive   = false                                          ,
        --icon        = utils.tools.invertedIconPath("image.png")      ,
        layout      = awful.layout.tile                              ,
        nmaster     = 1                                              ,
        incncol     = 10                                             ,
        ncol        = 2                                              ,
        mwfact      = 0.00                                           ,
        class       = {}
    } ,
    {
        name        = "Other",
        init        = true                                           ,
        position    = 15                                             ,
        exclusive   = false                                          ,
        fallback    = true ,
        selected    = true                                           ,
        --icon        = utils.tools.invertedIconPath("term.png")       ,
        screen      = {1, 2, 3}                                      ,
        layout      = awful.layout.suit.tile                         ,
        class       = {}
    } ,
    {
        name        = "MediaCenter",
        init        = true                                           ,
        position    = 15                                             ,
        exclusive   = false                                          ,
        --icon        = utils.tools.invertedIconPath("video.png")      ,
        max_clients = 5                                              ,
        screen      = 1   ,
        init        = "mythfrontend"                                 ,
        layout      = awful.layout.suit.tile                         ,
        class       = {"mythfrontend"  , "xbmc" , "xbmc.bin"        ,}
    } ,
}

tyrannical.properties.intrusive = {
    "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"           ,
    "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color",
    "kcolorchooser" , "plasmoidviewer" , "plasmaengineexplorer" , "Xephyr" , "kruler"     ,
    "yakuake"       , "pinentry-gtk-2", 
    "sflphone-client-kde", "sflphone-client-gnome", "xev", "lxpolkit",
}
tyrannical.properties.floating = {
    "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
    "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
    "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
    "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer" ,
    "sflphone-client-kde", "sflphone-client-gnome", "xev", "pinentry-gtk-2",
    amarok = false , "yakuake", "Conky", "lxpolkit",
}

tyrannical.properties.ontop = {
    "Xephyr"       , "ksnapshot"       , "kruler"
}

tyrannical.properties.focusable = {
    conky=false
}


tyrannical.properties.no_autofocus = {
    "Conky"
}

tyrannical.properties.below = {
    "Conky"
}

tyrannical.properties.maximize = {
    amarok = false, kodi=false,
}

tyrannical.properties.fullscreen = {
    kodi = false,
}

-- tyrannical.properties.border_width = {
--     URxvt = 0
-- }

tyrannical.properties.border_color = {
    Termite = "#0A1535"
}

tyrannical.properties.intrusive_popup = {
    "transmission-qt"
}

tyrannical.properties.centered = { "kcalc" }

tyrannical.properties.skip_taskbar = {"yakuake"}
tyrannical.properties.hidden = {"yakuake"}

-- tyrannical.properties.no_autofocus = {"umbrello"}

tyrannical.properties.size_hints_honor = { URxvt = false, aterm = false, sauer_client = false, mythfrontend  = false, kodi = false, Termite = false}
