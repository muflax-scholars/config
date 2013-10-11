-- load libraries
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- fall back to preset config if errors are found
if awesome.startup_errors then
  naughty.notify({preset = naughty.config.presets.critical,
                  title = "Oops, there were errors during startup!",
                  text = awesome.startup_errors})
end

-- handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
                           -- make sure we don't go into an endless error loop
                           if in_error then return end
                           in_error = true

                           naughty.notify({preset = naughty.config.presets.critical,
                                           title = "Oops, an error happened!",
                                           text = err})
                           in_error = false
  end)
end

-- visual settings
beautiful.init(awful.util.getdir("config") .. "/themes/blue/theme.lua")
if beautiful.wallpaper then
  for s = 1, screen.count() do
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
  end
end
-- }}}

-- default apps
terminal = "urxvt"
editor = "emacs-gui"

dmenu_font  = "-mplus-gothic-medium-r*12"
dmenu_opts  = "-b -i -fn '"..dmenu_font.."' -nb '#000000' -nf '#FFFFFF' -sb '"..beautiful.border_normal.."'"
dmenu       = "dmenu "..dmenu_opts
dmenu_all   = "dmenu_run "..dmenu_opts
dmenu_quick = "eval \"exec `cat $HOME/.programs | "..dmenu.."`\""

-- keybindings
modkey = "Mod4"

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  -- move through tags
  awful.key({ modkey,           }, "h",   awful.tag.viewprev),
  awful.key({ modkey,           }, "g",   awful.tag.viewnext),

  -- -- prev / next workspace
  -- , ((modm,               xK_h     ), windows . W.greedyView =<< findWorkspace getSortByIndexNoSP Next HiddenNonEmptyWS 1)
  -- , ((modm .|. shiftMask, xK_h     ), windows . W.greedyView =<< findWorkspace getSortByIndexNoSP Prev HiddenNonEmptyWS 1)
  
  -- move through screens
  awful.key({ modkey, "Shift"   }, "h", function () awful.screen.focus_relative(-1) end),
  awful.key({ modkey, "Shift"   }, "g", function () awful.screen.focus_relative(1) end),
  -- focus history
  awful.key({ modkey,           }, "Tab", awful.tag.history.restore),
  awful.key({ modkey, "Shift"   }, "Tab", function ()
              awful.client.focus.history.previous()
              if client.focus then
                client.focus:raise()
              end end),

  -- move client focus up/down
  awful.key({ modkey,           }, "n", function ()
              awful.client.focus.byidx(-1)
              if client.focus then client.focus:raise() end end),
  awful.key({ modkey,           }, "r", function ()
              awful.client.focus.byidx(1)
              if client.focus then client.focus:raise() end end),

  -- jump to urgent client
  awful.key({ modkey,           }, "x", awful.client.urgent.jumpto),

  -- move clients around
  awful.key({ modkey, "Shift"   }, "n", function () awful.client.swap.byidx(-1) end),
  awful.key({ modkey, "Shift"   }, "r", function () awful.client.swap.byidx(1) end),

  -- layouts
  awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
  -- reset layouts
  -- , ((modm .|. altMask,   xK_space   ), setLayout $ XMonad.layoutHook conf)

  -- resize winodws
  awful.key({ modkey,           }, "d", function () awful.tag.incnmaster( 1) end),
  awful.key({ modkey, "Shift"   }, "d", function () awful.tag.incnmaster(-1) end),
  awful.key({ modkey, "Control" }, "r", function () awful.tag.incmwfact( 0.05) end),
  awful.key({ modkey, "Control" }, "n", function () awful.tag.incmwfact(-0.05) end),

  -- minimize / restore window
  awful.key({ modkey,           }, "|", function (c)
              c.minimized = true end),
  awful.key({ modkey, "Control" }, "|", awful.client.restore),
  
  -- toggles
  -- , ((modm,               xK_f     ), sendMessage $ Toggle NBFULL )
  -- , ((modm,               xK_y     ), sendMessage $ Toggle REFLECTX )
  -- , ((modm .|. shiftMask, xK_y     ), sendMessage $ Toggle REFLECTY )
  -- , ((modm,               xK_m     ), sendMessage $ Toggle MIRROR )
  -- , ((modm,               xK_b     ), sendMessage $ Toggle NOBORDERS )
  -- , ((modm .|. shiftMask, xK_b     ), sendMessage ToggleStruts )

  -- launch scratchpad
  -- , ((modm,               xK_i     ), scratchpad)
  -- , ((modm,               xK_p     ), namedScratchpadAction scratchpads "pidgin")
  -- , ((modm,               xK_a     ), namedScratchpadAction scratchpads "anking")

  -- launch terminal
  awful.key({ modkey,           }, "u", function () awful.util.spawn(terminal) end),

  -- launch dmenu
  awful.key({ modkey,           }, "e", function () awful.util.spawn_with_shell(dmenu_quick) end),
  awful.key({ modkey,           }, "o", function () awful.util.spawn(dmenu_all) end),
  
  -- rotate screen
  awful.key({ modkey,           }, "j", function () awful.util.spawn("rotate_screen normal") end),
  awful.key({ modkey, "Shift"   }, "j", function () awful.util.spawn("rotate_screen left") end),
  awful.key({ modkey, "Control" }, "j", function () awful.util.spawn("rotate_screen right") end),

  -- volume control
  awful.key({                   }, "XF86AudioLowerVolume", function ()
              awful.util.spawn("amixer -c 0 set Master -q 5-") end),
  awful.key({ "Shift"           }, "XF86AudioLowerVolume", function ()
              awful.util.spawn("amixer -c 0 set Master -q 5+") end),

  -- mpc
  awful.key({ modkey,           }, "c", function ()
              awful.util.spawn_with_shell("MPD_HOST=localhost mpc --no-status toggle") end),
  awful.key({ modkey, "Shift"   }, "c", function () awful.util.spawn("remember_song.sh") end),
  awful.key({ modkey, "Control" }, "c", function ()
              awful.util.spawn_with_shell("MPD_HOST=localhost mpc del 0") end),

  -- screenshots
  awful.key({ modkey, "Shift"   }, "o", function ()
              awful.util.spawn("$HOME/src/scripts/selection >/dev/null") end),
  
  -- switch to different machine
  awful.key({ modkey, "Control" }, "1", function () awful.util.spawn("scabeiathrax_display") end),
  awful.key({ modkey, "Control" }, "2", function () awful.util.spawn("typhus_display") end),
  
  -- change keyboard settings
  awful.key({ modkey,           }, "k", function () awful.util.spawn("skb.sh") end),
  awful.key({ modkey, "Shift"   }, "k", function () awful.util.spawn("setxkbmap us") end),
  awful.key({ modkey, "Control" }, "k", function () awful.util.spawn("toggle_repeat.rb") end),

  -- backlights
  awful.key({ modkey,           }, "XF86MonBrightnessDown", function ()
              awful.util.spawn("sudo $HOME/src/misc/apple/light/light.rb decrement") end),
  awful.key({ modkey,           }, "XF86MonBrightnessUp", function ()
              awful.util.spawn("sudo $HOME/src/misc/apple/light/light.rb increment") end),
  awful.key({ modkey,           }, "XF86LaunchA", function ()
              awful.util.spawn("sudo $HOME/src/misc/apple/light/light.rb keyboard") end),

  -- restart awesome
  awful.key({ modkey, "Shift"   }, "q", awesome.restart)
)

-- client-specific keys
clientkeys = awful.util.table.join(
  -- client movement
  awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey, "Shift"   }, "Return", function (c) c.ontop = not c.ontop end),
  awful.key({ modkey, "Control" }, "Return", function (c) c.fullscreen = not c.fullscreen  end),

  -- close it
  awful.key({ modkey, "Shift"   }, "w", function (c) c:kill() end),

  -- float it
  awful.key({ modkey,           }, "t", awful.client.floating.toggle),
  awful.key({ modkey, "Shift"   }, "t", function (c) awful.client.floating.set(c, false) end)
)

-- bind all key numbers to tags
for i = 1, 9 do
  globalkeys = awful.util.table.join(
    globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
              function ()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                  awful.tag.viewonly(tag)
                end
    end),
    awful.key({ modkey, "Control" }, "#" .. i + 9,
              function ()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                  awful.tag.viewtoggle(tag)
                end
    end),
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
              function ()
                local tag = awful.tag.gettags(client.focus.screen)[i]
                if client.focus and tag then
                  awful.client.movetotag(tag)
                end
    end),
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
              function ()
                local tag = awful.tag.gettags(client.focus.screen)[i]
                if client.focus and tag then
                  awful.client.toggletag(tag)
                end
  end))
end

-- set keys
root.keys(globalkeys)

-- mouse bindings; note that the order is left (1), middle (2), right (3)
clientbuttons = awful.util.table.join(
  -- floating clients
  awful.button({ modkey            }, 1,
               function()
                 local c = awful.mouse.client_under_pointer()
                 if c then
                   awful.client.floating.toggle(c)
                 end
  end),

  awful.button({ modkey, "Shift"   }, 1, awful.mouse.client.move),
  awful.button({ modkey, "Control" }, 1, awful.mouse.client.resize))

-- open menu on empty screen
root.buttons(awful.util.table.join(awful.button({ }, 1, function () awesome_menu:toggle() end)))

-- layouts
local layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.fair,
  awful.layout.suit.max.fullscreen,
}

-- tags
tags = {}
for s = 1, screen.count() do
  -- each screen has its own tag table.
  tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end

-- rules
awful.rules.rules = {
  -- all clients
  { rule = { },
    properties = { border_width = beautiful.border_width,
                   border_color = beautiful.border_normal,
                   focus = awful.client.focus.filter,
                   keys = clientkeys,
                   buttons = clientbuttons } },

  -- keep these floating
  { rule = { class = "mplayer2" },
    properties = { floating = true } },
  { rule = { class = "pinentry" },
    properties = { floating = true } },
  { rule = { class = "gimp" },
    properties = { floating = true } },
  { rule = { class = "Screenkey" },
    properties = { floating = true } },
  { rule = { class = "Gxmessage" },
    properties = { floating = true } },

  -- put these in specific tags
  { rule = { class = "Firefox" },
    properties = { tag = tags[1][9] } },
}

-- signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
                        -- enable mouse focus
                        c:connect_signal("mouse::enter", function(c)
                                           if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                                           and awful.client.focus.filter(c) then
                                             client.focus = c
                                           end
                        end)

                        if not startup then
                          -- make new windows slaves
                          if not c.size_hints.user_position and not c.size_hints.program_position then
                            awful.placement.no_overlap(c)
                            awful.placement.no_offscreen(c)
                          end
                        end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- menu / launcher
awesome_menu = awful.menu({items = {
                            { "open terminal", terminal },
                            { "edit config", editor .. " " .. awesome.conffile },
                            { "restart", awesome.restart }}})
launcher = awful.widget.launcher({image = beautiful.awesome_icon,
                                  menu = awesome_menu})

-- widgets
textclock = awful.widget.textclock()

-- status bar
awesome_wibox = {}
promptbox = {}
layoutbox = {}
taglist = {}
taglist.buttons = awful.util.table.join(
  awful.button({ }, 1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
tasklist = {}
tasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
                 if c == client.focus then
                   c.minimized = true
                 else
                   -- without this, the following :isvisible() makes no sense
                   c.minimized = false
                   if not c:isvisible() then
                     awful.tag.viewonly(c:tags()[1])
                   end
                   -- this will also un-minimize the client, if needed
                   client.focus = c
                   c:raise()
                 end
  end),
  awful.button({ }, 3, function ()
                 if instance then
                   instance:hide()
                   instance = nil
                 else
                   instance = awful.menu.clients({ width=250 })
                 end
  end),
  awful.button({ }, 4, function ()
                 awful.client.focus.byidx(1)
                 if client.focus then client.focus:raise() end
  end),
  awful.button({ }, 5, function ()
                 awful.client.focus.byidx(-1)
                 if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do
  -- Create a promptbox for each screen
  promptbox[s] = awful.widget.prompt()
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  layoutbox[s] = awful.widget.layoutbox(s)
  layoutbox[s]:buttons(awful.util.table.join(
                         awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                         awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                         awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                         awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
  -- Create a taglist widget
  taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist.buttons)

  -- Create a tasklist widget
  tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist.buttons)

  -- Create the wibox
  awesome_wibox[s] = awful.wibox({ position = "bottom", screen = s })

  -- Widgets that are aligned to the left
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(launcher)
  left_layout:add(taglist[s])
  left_layout:add(promptbox[s])

  -- Widgets that are aligned to the right
  local right_layout = wibox.layout.fixed.horizontal()
  if s == 1 then right_layout:add(wibox.widget.systray()) end
  right_layout:add(textclock)
  right_layout:add(layoutbox[s])

  -- Now bring it all together (with the tasklist in the middle)
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(tasklist[s])
  layout:set_right(right_layout)

  awesome_wibox[s]:set_widget(layout)
end
