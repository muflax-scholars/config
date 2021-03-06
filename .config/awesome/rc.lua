-- load libraries
local gears      = require("gears")
local awful      = require("awful")
awful.rules      = require("awful.rules")
require("awful.autofocus")
local wibox      = require("wibox")
local beautiful  = require("beautiful")
local naughty    = require("naughty")
local eminent    = require("eminent")
local scratchpad = require("scratchpad")
local lain       = require("lain")
local helpers    = require("lain.helpers")
local markup     = lain.util.markup

io.stderr:write("======================================\n")
io.stderr:write("This gonna be - wait for it - LEGEN...\n")
io.stderr:write("======================================\n")

-- fall back to preset config if errors are found
if awesome.startup_errors then
  naughty.notify({preset = naughty.config.presets.critical,
                  title  = "Oops, there were errors during startup!",
                  text   = awesome.startup_errors})
end

function debug(text)
  naughty.notify({preset = naughty.config.presets.critical,
                  title  = "Debug:",
                  text   = text})
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

function chomp_read(command)
  return awful.util.pread(command):gsub("\n$", "")
end


-- localization
os.setlocale(os.getenv("LANG"))

-- for host-specific settings
local hostname = chomp_read("hostname")

-- visual settings
local theme = "multicolor"
beautiful.init(awful.util.getdir("config") .. "/themes/"..theme.."/theme.lua")

-- layouts
local layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.top,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
}

function toggleLayouts(a, b) -- a is preferred default
  if awful.layout.get(mouse.screen) == a then
    awful.layout.set(b)
  else
    awful.layout.set(a)
  end
end

function toggleHorizontalTiling()
  toggleLayouts(awful.layout.suit.tile.bottom, awful.layout.suit.tile.top)
end

function toggleVerticalTiling()
  toggleLayouts(awful.layout.suit.tile, awful.layout.suit.tile.left)
end

function toggleGridTiling()
  toggleLayouts(awful.layout.suit.fair, awful.layout.suit.fair.horizontal)
end

function toggleFullScreenTiling()
  toggleLayouts(awful.layout.suit.max.fullscreen, awful.layout.suit.magnifier)
end

-- default apps
editor = "emacs-gui"

dmenu_font  = "-mplus-gothic-medium-r*12"
dmenu_opts  = "-b -i -fn '"..dmenu_font.."' -nb '#000000' -nf '#FFFFFF' -sb '"..beautiful.border_normal.."'"
dmenu       = "dmenu "..dmenu_opts
dmenu_all   = "dmenu_run "..dmenu_opts
dmenu_quick = "eval \"exec `cat $HOME/.programs | "..dmenu.."`\""

-- scratchpads
local scratchpad_term = scratchpad({ command = "konsole --name scratchpad -e zsh -l -c 'scratchpad'",
                                     name    = "scratchpad",
			                               height  = 0.7,
                                     width   = 0.6})
local scratchpad_anking = scratchpad({ command = "anking -n",
                                       name    = "anking",
                                       height  = 0.7,
                                       width   = 0.5})

-- disable mouse
function mouse_toggle()
  awful.util.spawn("toggle_mouse.rb")
  -- move cursor in lower left corner and don't trigger any events
  mouse.coords({x=0, y=screen[1][1]}, true)
end

-- run the command if it not exists, otherwise raise/kill it (and rely on tool itself to tray)
function run_or_raise(command, rule, active_hide)
  active_hide = active_hide or false

  local matcher = function (c)
    return awful.rules.match(c, rule)
  end

  local kill_or_hide = function (c)
    if active_hide then
      -- FIXME implement
    else
      c:kill()
    end
  end

  local find_client = function ()
    for c in awful.client.iterate(function (cc)
                                    return matcher(cc)
                                  end, nil, nil) do
      return c
    end

    return nil
  end


  if client.focus and matcher(client.focus) then
    kill_or_hide(client.focus)
  else
    c = find_client()

    if c then
      if c:tags()[mouse.screen] == awful.tag.selected(mouse.screen) then
        client.focus = c
        c:raise()
      else
        awful.client.jumpto(c)
      end
    else
      awful.util.spawn(command)
    end
  end
end

function close_last_notification()
  for screen = 1, screen.count() do
    for p,pos in pairs(naughty.notifications[screen]) do
      for i,n in pairs(naughty.notifications[screen][p]) do
        naughty.destroy(n)
        return true
      end
    end

    return false
  end
end

function close_all_notifications()
    n = close_last_notification()
    while n do
      n = close_last_notification()
    end
end

-- keybindings
modkey = "Mod4"
globalkeys = awful.util.table.join(
  -- move through tags
  awful.key({ modkey,           }, "h",   awful.tag.viewnext),
  awful.key({ modkey, "Shift"   }, "h",   awful.tag.viewprev),

  -- move through screens
  awful.key({ modkey,           }, "g", function () awful.screen.focus_relative(1) end),
  awful.key({ modkey, "Shift"   }, "g", function () awful.screen.focus_relative(-1) end),
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

  -- restore first minimized window
  awful.key({ modkey, "Shift"   }, "v", function ()
              for _, c in ipairs(client.get(mouse.screen)) do
                if (c.minimized
                    and c:tags()[mouse.screen] == awful.tag.selected(mouse.screen)) then
                  c.minimized = false
                  client.focus = c
                  c:raise()
                  return
                end
              end
  end ),

  -- restore all minimized windows
  awful.key({ modkey, "Control" }, "v", function ()
              local gave_focus = false -- give focus to first in list
              for _, c in ipairs(client.get(mouse.screen)) do
                if (c.minimized
                    and c:tags()[mouse.screen] == awful.tag.selected(mouse.screen)) then
                  c.minimized = false
                  c:raise()
                  if not gave_focus then
                    client.focus = c
                    gave_focus = true
                  end
                end
              end
  end ),

  -- move clients around
  awful.key({ modkey, "Shift"   }, "n", function () awful.client.swap.byidx(-1) end),
  awful.key({ modkey, "Shift"   }, "r", function () awful.client.swap.byidx(1) end),

  -- fast toggling of layouts
  awful.key({ modkey,           }, "m", toggleVerticalTiling),
  awful.key({ modkey, "Shift"   }, "m", toggleHorizontalTiling),
  awful.key({ modkey, "Control" }, "m", toggleGridTiling),
  awful.key({ modkey, "Shift"   }, "f", toggleFullScreenTiling),

  -- clear notifications
  awful.key({ modkey,           }, "b", close_last_notification),
  awful.key({ modkey, "Shift"   }, "b", close_all_notifications),

  -- resize windows
  awful.key({ modkey, "Control" }, "r", function () awful.tag.incmwfact( 0.05) end),
  awful.key({ modkey, "Control" }, "n", function () awful.tag.incmwfact(-0.05) end),

  -- launch scratchpad
  awful.key({ modkey,           }, "i", function () scratchpad_term:toggle() end),

  -- launch dmenu
  awful.key({ modkey,           }, "e", function () awful.util.spawn_with_shell(dmenu_quick) end),
  awful.key({ modkey,           }, "o", function () awful.util.spawn(dmenu_all) end),

  -- lock screen
  awful.key({ modkey            }, "Escape", function () awful.util.spawn("slock") end),

  -- toggle trackpad
  awful.key({ modkey            }, "y", mouse_toggle),
  awful.key({ modkey, "Shift"   }, "y", function () awful.util.spawn("toggle_laptop_keyboard.rb") end),

  -- volumecontrol
  awful.key({ modkey            }, "u", function ()
              awful.util.spawn("amixer -c 0 set Master -q 5-")
              volume:update()
  end),
  awful.key({ modkey, "Shift"   }, "u", function ()
              awful.util.spawn("amixer -c 0 set Master -q 5+")
              volume:update()
  end),

  -- mpc
  awful.key({ modkey,           }, "c", function ()
              awful.util.spawn_with_shell("MPD_HOST=localhost mpc --no-status toggle") end),

  -- change keyboard settings
  awful.key({                   }, "Scroll_Lock", function () awful.util.spawn("skb.sh") end),

  -- backlights
  awful.key({                   }, "XF86MonBrightnessDown", function ()
              awful.util.spawn_with_shell("$HOME/src/misc/apple/light/light.rb decrement") end),
  awful.key({                   }, "XF86MonBrightnessUp", function ()
              awful.util.spawn_with_shell("$HOME/src/misc/apple/light/light.rb increment") end),
  awful.key({ modkey            }, "F11", function ()
              awful.util.spawn_with_shell("$HOME/src/misc/apple/light/light.rb decrement") end),
  awful.key({ modkey            }, "F12", function ()
              awful.util.spawn_with_shell("$HOME/src/misc/apple/light/light.rb increment") end),
  awful.key({                   }, "XF86LaunchA", function ()
              awful.util.spawn_with_shell("$HOME/src/misc/apple/light/light.rb keyboard") end),

  -- konsole
  awful.key({ modkey            }, "k", function () awful.util.spawn("konsole") end)

)

-- client-specific keys
clientkeys = awful.util.table.join(
  -- client movement
  awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey, "Shift"   }, "Return", function (c) c.ontop = not c.ontop end),

  -- fullscreen it
  awful.key({ modkey            }, "f", function (c) c.fullscreen = not c.fullscreen  end),

  -- close it
  awful.key({ modkey, "Shift"   }, "w", function (c) c:kill() end),

  -- minimize window
  awful.key({ modkey,           }, "v", function (c) c.minimized = true end),

  -- float it
  awful.key({ modkey,           }, "t", awful.client.floating.toggle),
  awful.key({ modkey, "Shift"   }, "t", function (c) awful.client.floating.set(c, false) end)
)

-- bind all key numbers to tags
for i = 1, 10 do
  globalkeys = awful.util.table.join(
    globalkeys,
    awful.key({ modkey }, tostring(i % 10),

              function ()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                  awful.tag.viewonly(tag)
                end
    end),
    awful.key({ modkey, "Control" }, tostring(i % 10),

              function ()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                  awful.tag.viewtoggle(tag)
                end
    end),
    awful.key({ modkey, "Shift" }, tostring(i % 10),

              function ()
                local tag = awful.tag.gettags(client.focus.screen)[i]
                if client.focus and tag then
                  awful.client.movetotag(tag)
                end
    end),
    awful.key({ modkey, "Control", "Shift" }, tostring(i % 10),

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
  awful.button({                 }, 1,
    function()
      client.focus = awful.mouse.client_under_pointer()
      client.focus:raise()
  end),
  awful.button({                 }, 2,
    function()
      client.focus = awful.mouse.client_under_pointer()
      client.focus:raise()
  end),
  awful.button({                 }, 3,
    function()
      client.focus = awful.mouse.client_under_pointer()
      client.focus:raise()
  end),
  awful.button({                 }, 4,
    function()
      client.focus = awful.mouse.client_under_pointer()
      client.focus:raise()
  end),
  awful.button({                 }, 5,
    function()
      client.focus = awful.mouse.client_under_pointer()
      client.focus:raise()
  end),

  awful.button({ modkey          }, 1, awful.mouse.client.move),
  awful.button({ modkey, "Shift" }, 1,
    function()
      local c = awful.mouse.client_under_pointer()
      if c then
        awful.client.floating.toggle(c)
      end
  end),
  awful.button({ modkey          }, 3, awful.mouse.client.resize))

-- tag options
local default_layout  = layouts[1]
local default_mwfact  = 0.6
local default_nmaster = 1
local default_ncol    = 1

-- tags
tags = {}
tag_names = {
  "一",
  "二",
  "三",
  "四",
  "五",
  "六",
  "七",
  "八",
  "九",
  "十",
}
for s = 1, screen.count() do
  -- each screen has its own tag table for now
  tags[s] = awful.tag(tag_names, s, default_layout)

  for i = 1, #tag_names do
    awful.tag.setmwfact  (default_mwfact,  t)
    awful.tag.setnmaster (default_nmaster, t)
    awful.tag.setncol    (default_ncol,    t)
  end
end

-- rules for automatic focus switching
function full_focus_filter(client)
  local stupid_client = false -- is the client stupid?
  local default_focus = true  -- whether to give a client focus by default

  -- pidgin is annoying, so prevent its conversations from stealing focus
  if client.class == "Pidgin" and client.role == "conversation" then
    stupid_client = true
  end

  return (default_focus and not stupid_client and awful.client.focus.filter)
end

-- client rules
awful.rules.rules = {
  -- defaults for all clients
  { rule = { },
    properties = { border_width = beautiful.border_width,
                   border_color = beautiful.border_normal,
                   focus        = full_focus_filter,
                   keys         = clientkeys,
                   buttons      = clientbuttons,
                   callback     = awful.client.setslave }},

  -- ignore that stupid urxvt gap
  { rule_any = { class = { "URxvt", "Emacs" } },
    properties = { size_hints_honor = false }},

  -- float these by default
  { rule_any = { class = {
                   "mplayer",
                   "mplayer2",
                   "mpv",
                   "pinentry",
                   "Wine",
                   "Gxmessage",
                   "anking",
                   "Plugin-container",
                   "Plover",
               }},
    properties = { floating = true }},

  -- keep them on top
  { rule_any = { class = {
                   "mplayer",
                   "mplayer2",
                   "mpv",
                   "Plover",
               }},
    properties = { ontop  = true,
                   sticky = true,
  }},

  -- floating and sticky
  { rule = { role = "buddy_list" },
    properties = { floating = true, sticky = true }},

    -- default tags
  { rule_any = { class = { "Pidgin",
                           "Firefox",
                           "Chromium-browser",
                           "Google-chrome"}},
    properties = { tag = tags[1][10] }},
  { rule_any = { class = { "Runanki"}},
    properties = { tag = tags[1][9] }},

}

-- signals
client.connect_signal("manage", function (c, startup)
                        if not startup then
                          -- make new windows slaves
                          if not c.size_hints.user_position and not c.size_hints.program_position then
                            awful.placement.no_overlap(c)
                            awful.placement.no_offscreen(c)
                          end
                        end
end)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- widgets

-- clock
clockicon = wibox.widget.imagebox(beautiful.widget_clock)
-- FIXME this is ugly :<
clock     = wibox.widget.textbox()
clock_timer = helpers.newtimer
clock_timer("clock", 0.9, function()
              local mom_t = chomp_read('TZ="Europe/Berlin" date "+m:%H"')
              local us_t  = chomp_read('TZ="America/Los_Angeles" date "+u:%H"')
              clock:set_markup(
                -- date
                markup("#7788af", os.date("%d(%a) "))

                -- other time
                  ..markup("#343639", "[")
                  ..markup("#de5e1e", us_t)
                  ..markup("#343639", "|")
                  ..markup("#de5e1e", mom_t)
                  ..markup("#343639", "]")

                -- local time
                  ..markup("#de5e1e", os.date("%H時%M分%S秒")))
end)

-- CPU
cpuicon   = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpu = lain.widgets.cpu({
    settings = function()
      widget:set_markup(markup("#e33a6e", cpu_now.usage .. "% "))
    end
})

-- Battery
baticon = wibox.widget.imagebox(beautiful.widget_batt)
local local_battery = "BAT0"
if hostname == "typhus" then -- different name, for some reason
  local_battery = "BAT1"
end
bat = lain.widgets.bat({ battery = local_battery,
                         settings = function()
                           if bat_now.perc == "N/A" then
                             bat_now.perc = "AC "
                           else
                             bat_now.perc = bat_now.perc .. "% "
                           end

                           local status = ""
                           if bat_now.status == "Charging" then
                             status = "+"
                           elseif bat_now.status == "Discharging" then
                             status = "-"
                           end

                           widget:set_text(status..bat_now.perc)
                         end
})

-- ALSA volume
volicon = wibox.widget.imagebox(beautiful.widget_vol)
volume = lain.widgets.alsa({
                             settings = function()
                               if volume_now.status == "off" then
                                 volume_now.level = volume_now.level .. "M"
                               end
                               widget:set_markup(markup("#7493d2", volume_now.level .. "% "))
                             end
})

-- MEM
memicon = wibox.widget.imagebox(beautiful.widget_mem)
mem = lain.widgets.mem({
                         settings = function()
                           widget:set_markup(markup("#e0da37", mem_now.used .. "M "))
                         end
})

spacer = wibox.widget.textbox(" ")

-- status bar
awesome_wibox = {}
promptbox     = {}
layoutbox     = {}
taglist       = {}

-- tags
taglist.buttons = awful.util.table.join(
  awful.button({ }, 1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag))

-- taskbar
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
  end))

for s = 1, screen.count() do
  promptbox[s] = awful.widget.prompt()

  layoutbox[s] = awful.widget.layoutbox(s)
  layoutbox[s]:buttons(awful.util.table.join(
                         awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                         awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end)))

  taglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist.buttons)

  -- TODO make it more elaborate, maybe by splitting off minimized tasks?
  tasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist.buttons)

  -- Create the wibox
  awesome_wibox[s] = awful.wibox({ position = "bottom", screen = s })

  -- aligned to the left
  local left_layout = wibox.layout.fixed.horizontal()
  left_layout:add(layoutbox[s])
  left_layout:add(taglist[s])
  left_layout:add(promptbox[s])
  left_layout:add(spacer)

  -- aligned to the right
  local right_layout = wibox.layout.fixed.horizontal()
  -- right_layout:add(fume) -- TODO
  right_layout:add(wibox.widget.systray())
  right_layout:add(spacer)
  right_layout:add(baticon)
  right_layout:add(bat)
  right_layout:add(cpuicon)
  right_layout:add(cpu)
  right_layout:add(memicon)
  right_layout:add(mem)
  right_layout:add(volicon)
  right_layout:add(volume)
  right_layout:add(clockicon)
  right_layout:add(clock)

  -- tasklist in the middle
  local layout = wibox.layout.align.horizontal()
  layout:set_left(left_layout)
  layout:set_middle(tasklist[s])
  layout:set_right(right_layout)

  awesome_wibox[s]:set_widget(layout)
end

io.stderr:write("========\n")
io.stderr:write("...DARY!\n")
io.stderr:write("========\n")
