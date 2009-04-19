-- awesome 3 configuration file

io.stderr:write("===========================\n")
io.stderr:write("This is gonna be awesome...\n")
io.stderr:write("===========================\n")

require("awful")
require("tabulous")
require("wicked")
require("beautiful")
require('naughty')

f = io.popen('hostname')
hostname = f:read()
f:close()

f = io.popen('whoami')
username = f:read()
f:close()
     
theme_path = "/home/"..username.."/.config/awesome/theme"
beautiful.init(theme_path)

naughty.config.position         = "bottom_right"
naughty.config.font             = beautiful.font
naughty.config.fg               = beautiful.fg_focus
naughty.config.bg               = beautiful.bg_focus
naughty.config.border_color     = beautiful.border_focus

-- {{{ Variable definitions
-- This is used later as the default terminal to run.
terminal = "urxvtcd"
dmenu = "dmenu -b -fn '-*-profont-*-r-normal-*-*-160-*-*-*-*-iso8859-*' -nb '#000000' -nf '#FFFFFF' -sb '#0066ff'"
menu = "$(dmenu_path | "..dmenu.." -i )"

-- {{{ Modkeys
modkey = "Mod4"
shift = "Shift"
alt = "Mod1"
control = "Control"
-- }}}


-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
 
-- Table of clients that should be set floating
floating_rules =
{
    "wine",
    "tkifm",
    "mplayer",
    "gimp",
}

-- Transparency
trans_rules =
{
    ["anki"] = 0.8,
    ["evince"] = 0.8,
}

-- name = {tag, context, [context, ...]} 
tag_rules = {
    --[terminal] = {1, {"~h~"}},
    ["firefox"] = {1, "~a~"},
    ["navigator"] = {1, "~a~"},
    ["paradiso"] = {1, "~a~"},
    ["pidgin"] = {1, "~u~"},
    ["thunar"] = {1, "~h~"},
    ["anki"] = {1, "~r~"},
    ["wine"] = {1, "~i~"},
    ["evince"] = {1, "~l~"},
    ["comix"] = {1, "~e~"},
    ["geeqie"] = {1, "~q~"},
    ["jd"] = {1, "~u~"},
    ["xchat"] = {1, "~u~"},
--    [""] = {1, "~n~"}
}


-- Color & Appearance definitions, we use these later to display things
spacer = " "
separator = " "
default_mwfact = 0.60

-- {{{ Markup helper functions
-- Inline markup is a tad ugly, so use these functions
-- to dynamically create markup.
function bg(color, text)
    return '<bg color="'..color..'" />'..text
end

function fg(color, text)
    return '<span color="'..color..'">'..text..'</span>'
end
                     
function font(font, text)
    return '<span font_desc="'..font..'">'..text..'</span>'
end

function bold(text)
    return '<b>'..text..'</b>'
end

function heading(text)
    return fg(beautiful.fg_focus, bold(text))
end

-- }}}

-- Define if we want to use titlebar on all applications
use_titlebar = true

-- awesome.font_set(default_font)
--awesome.colors_set({ fg = fg_normal, bg = bg_normal })

-- }}}

if hostname == "kira" then
    mouse_active = 1
    x_safe = 300
    y_safe = 900 - 16 + 1

    function mouse_toggle()
        if mouse_active == 1 then
            mouse_active = 0
            mouse.coords({ x=x_safe, y=y_safe })
            awful.util.spawn("synclient TouchpadOff=1")
        else
            mouse_active = 1
            awful.util.spawn("synclient TouchpadOff=0")
        end
    end

    -- startup
    -- mouse_toggle()
end

-- {{{ Key combinations
k_n = {}
k_m = {modkey}
k_ms = {modkey, shift}
k_ma = {modkey, alt}
k_mc = {modkey, control}
k_a = {alt}
k_ac = {alt, control}
k_as = {alt, shift}
k_c = {control}
k_cs = {control, shift}
k_s = {shift}

-- }}}

-- {{{ tags

tags = {}
tag_names = {  {{"~h~", default_mwfact, awful.layout.suit.fair}, 
                {"~a~", default_mwfact, awful.layout.suit.tile},
                {"~r~", default_mwfact, awful.layout.suit.tile},
                {"~l~", default_mwfact, awful.layout.suit.tile},
                {"~e~", default_mwfact, awful.layout.suit.tile},
                {"~q~", default_mwfact, awful.layout.suit.tile},
                {"~u~", default_mwfact, awful.layout.suit.fair},
                {"~i~", default_mwfact, awful.layout.suit.tile},
                {"~n~", default_mwfact, awful.layout.suit.tile}},
             
               {{"test", default_mwfact, awful.layout.suit.tile}}
            }
tags_by_name = {}

-- assume screen.count() <= 2
for s=1, screen.count() do
    tags[s] = {}
    for tagnumber = 1, #tag_names[s] do
        t = tag_names[s][tagnumber]
        tags[s][tagnumber] = tag(t[1])
        
        tags[s][tagnumber].mwfact = t[2]

        tags[s][tagnumber].screen = s
        
        awful.layout.set(t[3], tags[s][tagnumber])

    end
    tags[s][1].selected = true

    ts = {}
    for i = 1, #tags[s] do
        ts[tags[s][i].name] = tags[s][i]
    end
    tags_by_name[s] = ts
end

-- }}}
-- {{{ Taglist
mybuttons = {
    button(k_n, 1, awful.tag.viewonly),
    button(k_m, 1, awful.client.movetotag),
    button(k_n, 3, function (tag) tag.selected = not tag.selected end),
    button(k_m, 3, awful.client.toggletag),
    button(k_n, 5, awful.tag.viewnext),
    button(k_n, 4, awful.tag.viewprev)
}

mytaglist = {}
for s=1, screen.count() do
    mytaglist[s] = awful.widget.taglist.new(s, awful.widget.taglist.label.all, mybuttons)
end


-- }}}

-- refresh interval for wicked widgets
interval = 1

-- {{{ Date Widget
os.setlocale("ja_JP.UTF-8")
datewidget = widget({
    type = "textbox",
    name = "datewidget",
    align = "right"
})
--- }}}

cyclewidget = widget({
    type = "textbox",
    name = "cyclewidget",
    align = "right"
})

if hostname == "kira" then
    -- used to park the mouse cursor
    parkingwidget = widget({
        type = "textbox",
        name = "parkingwidget",
        align = "left",
    })
    parkingwidget.text = " {  }"


    wifiwidget = widget({
        type = "textbox",
        name = "wifiwidget",
        align = "right",
    }) 

    wicked.register(wifiwidget, 'function', function (widget, args)
        local f = io.open("/sys/class/net/wlan0/wireless/link")
        local wifiStrength = f:read()
        f:close()
        return heading("W")..": "..wifiStrength.."%"..separator
    end, interval)  

    batterywidget = widget({
        type = "textbox",
        name = "batterywidget",
        align = "right",
    }) 

    wicked.register(batterywidget, 'function', function (widget, args)
        local f = io.popen('acpi')
        local l = f:lines()
        local v = '[~]'

        for line in l do
            if line:lower():find('discharging') ~= nil then
                v = "[-] "..line:sub(25)
            elseif line:lower():find('charging') ~= nil then
                v = "[+] "..line:sub(22)
            end
        end

        f:close()

        return heading('B')..": "..v
    end, interval)  

end

-- {{{ Volume Widget
volumewidget = widget({
    type = 'textbox',
    name = 'volumewidget',
    align = 'right'
})
if hostname == "mumm-ra" then
    mixer = "Software"
else 
    mixer = "Master"
end 

wicked.register(volumewidget, 'function', function (widget, args)  
   local f = io.popen('amixer get '..mixer)
--   local f = io.popen("ossmix codec3.jack.int-speaker.front")
   local l = f:lines()
   local v = ''

   for line in l do
       --if line:find('is currently set to') ~= nil then
       if line:find('%]') ~= nil then
            pstart = line:find('[', 0, true) + 1
            pend = line:find(']', 0, true) - 1
            v = line:sub(pstart, pend)
       end
   end

   f:close()

   return heading('V')..": "..v
end, interval)

-- {{{ Other Widget
spacerwidget = widget({ type = 'textbox', name = 'spacerwidget', align ='right' })
spacerwidget.text = spacer..separator

-- }}}

-- {{{ CPU Usage Widget
cputextwidget = widget({
    type = 'textbox',
    name = 'cputextwidget',
    align = 'right'
})

cputextwidget.text = spacer..heading('CPU')..': '..spacer..separator
wicked.register(cputextwidget, 'cpu', 
function (widget, args) 
    return spacer..heading('C')..string.format(": %3d%%", args[1])..spacer
end, interval) 

-- }}}

-- {{{ CPU Graph Widget
cpugraphwidget = widget({
    type = 'graph',
    name = 'cpugraphwidget',
    align = 'right'
})


cpugraphwidget.height = 0.85
cpugraphwidget.width = 45
cpugraphwidget.bg = '#333333'
cpugraphwidget.border_color = '#0a0a0a'
cpugraphwidget.grow = 'left'


cpugraphwidget:plot_properties_set('cpu', {
    fg = '#AEC6D8',
    fg_center = '#285577',
    fg_end = '#285577',
    vertical_gradient = false
})

wicked.register(cpugraphwidget, 'cpu', '$1', interval, 'cpu')

-- }}}

-- {{{ Memory Usage Widget
memtextwidget = widget({
    type = 'textbox',
    name = 'memtextwidget',
    align = 'right'
})

memtextwidget.text = spacer..heading('M')..': '..spacer..separator
wicked.register(memtextwidget, 'mem', 
function (widget, args) 
    return spacer..heading('M')..string.format(": %4dMB (%3d%%)", tonumber(args[2]), tonumber(args[1]))..spacer 
end, interval)

-- }}}

-- {{{ Memory Graph Widget
memgraphwidget = widget({
    type = 'graph',
    name = 'memgraphwidget',
    align = 'right'
})

memgraphwidget.height = 0.85
memgraphwidget.width = 45
memgraphwidget.bg = '#333333'
memgraphwidget.border_color = '#0a0a0a'
memgraphwidget.grow = 'left'

memgraphwidget:plot_properties_set('mem', {
    fg = '#AEC6D8',
    fg_center = '#285577',
    fg_end = '#285577',
    vertical_gradient = false
})

wicked.register(memgraphwidget, 'mem', '$1', interval, 'mem')

-- }}}

mylayoutbox = {}
for s = 1, screen.count() do
    mylayoutbox[s] = widget({ type = "imagebox", align = "left" })
    mylayoutbox[s]:buttons({ button(k_n, 1, function () awful.layout.inc(layouts, 1) end),
                             button(k_n, 3, function () awful.layout.inc(layouts, -1) end),
                             button(k_n, 4, function () awful.layout.inc(layouts, 1) end),
                             button(k_n, 5, function () awful.layout.inc(layouts, -1) end) })
end

-- Create a systray
mysystray = widget({ type = "systray", name = "mysystray", align = "right" })

-- {{{ Statusbar
mainstatusbar = {}
statusbar_status = {}

for s = 1, screen.count() do
    mainstatusbar[s] = wibox({ 
        position = "bottom", 
        height = 16,
        name = "mainstatusbar" .. s,                        
        fg = beautiful.fg_normal, 
        bg = beautiful.bg_normal })
    
    if hostname == "kira" then
        mainstatusbar[s].widgets = {
            mytaglist[s],
            mylayoutbox[s],
            parkingwidget,
            wifiwidget,
            batterywidget,
            cputextwidget,
            cpugraphwidget,
            spacerwidget,
            memtextwidget,
            memgraphwidget,
            spacerwidget,
            volumewidget,
            cyclewidget,
            datewidget,
        }
    else 
        mainstatusbar[s].widgets = {
            mytaglist[s],
            mylayoutbox[s],
            cputextwidget,
            cpugraphwidget,
            spacerwidget,
            memtextwidget,
            memgraphwidget,
            spacerwidget,
            volumewidget,
            cyclewidget,
            datewidget,
        }
    end

    mainstatusbar[s].screen = s
    statusbar_status[s] = 1
end
-- }}}                         


---- {{{ Application Launchers
-- Toggle music playing
globalkeys = {
key(k_m, "c", function () 
    awful.util.spawn("MPD_HOST=192.168.1.15 mpc toggle") end),

key(k_m, "x", function ()
    awful.util.spawn("scrot -e 'mv $f /home/"..username.."/pigs/Screenshots/'") end),

-- Launch a new terminal
key(k_m, "z", function () 
    awful.util.spawn(terminal) end),

-- Mod+e: Launch the menu application set before
key(k_m, "e", function () 
    awful.util.spawn(menu) end),

-- local
key(k_m, "u", function ()
    awful.util.spawn("amixer -q set "..mixer.." 5+") end),
--    awful.util.spawn("ossmix -q codec3.jack.int-speaker.front +5") end)

key(k_m, "udiaeresis", function ()
    awful.util.spawn("amixer -q set "..mixer.." 5-") end),
--    awful.util.spawn("ossmix -q codec3.jack.int-speaker.front -- -5") end)

-- remote
key(k_ms, "u", function ()
    awful.util.spawn("ssh -q amon@mumm-ra 'amixer -q -c0 set Software 5+'") end),

key(k_ms, "udiaeresis", function ()             
    awful.util.spawn("ssh -q amon@mumm-ra 'amixer -q -c0 set Software 5-'") end),

---- }}}

---- {{{ Client hotkeys
-- Close window
key(k_a, "w", function ()
    client.focus:kill() end),

-- Focus Prev/Next window
key(k_m, "n", function ()
    awful.client.focus.byidx(-1); if client.focus then client.focus:raise() end end),

key(k_m, "r", function ()
    awful.client.focus.byidx(1); if client.focus then client.focus:raise() end end),

-- Swap window with the Prev/Next one
key(k_ms, "n", function ()
    awful.client.swap.byidx(-1) end),

key(k_ms, "r", function ()
    awful.client.swap.byidx(1) end),

-- Toggle window floating
key(k_m, "#94", function ()
    awful.client.floating.toggle() end),
-- Mod+o (left of Z, not all keyboards have it): 
-- Make window master
key(k_m, "o", function ()
    awful.client.movetoscreen(client.focus) end),

key(k_ms, "o", function ()
    client.focus.fullscreen = not client.focus.fullscreen end),

---- }}}

---- {{{ Tag hotkeys
-- Switch to prev/next tag
key(k_m, "h", function()
    awful.tag.viewprev() end),

key(k_m, "g", function()
    awful.tag.viewnext() end),

-- Mod+{b/m}: Decrease/Increase the amount of masters
key(k_m, "b", function ()
    awful.tag.incnmaster(-1) end),

key(k_m, "m", function ()
    awful.tag.incnmaster(1) end),

key(k_mc, "b", function ()
    awful.tag.incncol(-1) end),

key(k_mc, "m", function ()
    awful.tag.incncol(1) end),
 


key(k_m, "s", function ()
    awful.tag.incmwfact(-0.05) end),
 
key(k_m, "t", function ()
    awful.tag.incmwfact(0.05) end),

key(k_ms, "s", function ()
    awful.client.incwfact(-0.05, client.focus) end),

key(k_ms, "t", function ()
    awful.client.incwfact(0.05, client.focus) end),

key(k_m, "d", function ()
    awful.tag.setmwfact(default_mwfact) end),  

key(k_ms, "d", awful.tag.history.restore),

---- }}}

---- {{{ Miscellaneous hotkeys
-- Mod+Alt+R: Restart awesome
key(k_ma, "r", 
    awesome.restart),

key(k_ma, "q",
    awesome.quit),

-- Mod+{h/g}: Switch to next/previous screen
key(k_m, "k", function ()
    awful.screen.focus(1) end),

key(k_m, "f", function ()
    awful.screen.focus(-1) end),

-- walk through layouts
key(k_m, "space", function () 
    awful.layout.inc(layouts, 1) end),
key(k_ms, "space", function () 
    awful.layout.inc(layouts, -1) end),


---- }}}

--- Tabulous, tab manipulation
key(k_ms, "y", function ()
    local tabbedview = tabulous.tabindex_get()
    local nextclient = awful.client.next(1)
 
    if tabbedview == nil then
        tabbedview = tabulous.tabindex_get(nextclient)
 
        if tabbedview == nil then
            tabbedview = tabulous.tab_create()
            tabulous.tab(tabbedview, nextclient)
        else
            tabulous.tab(tabbedview, client.focus)
        end
    else
        tabulous.tab(tabbedview, nextclient)
    end
end),
 
key(k_mc, "y", 
    tabulous.untab),
 
key(k_m, "y", function ()
   local tabbedview = tabulous.tabindex_get()
 
   if tabbedview ~= nil then
       local n = tabulous.next(tabbedview)
       tabulous.display(tabbedview, n)
   end
end),
}

if hostname == "kira" then 
    table.insert(globalkeys, key(k_m, "p", mouse_toggle))
end

---- {{{ Number keys
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
    table.insert(globalkeys, key(k_m, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           awful.tag.viewonly(tags[screen][i])
                       end
                   end))
    table.insert(globalkeys, key(k_mc, i,
                   function ()
                       local screen = mouse.screen
                       if tags[screen][i] then
                           tags[screen][i].selected = not tags[screen][i].selected
                       end
                   end))
    table.insert(globalkeys, key(k_ms, i,
                   function ()
                       local sel = client.focus
                       if sel then
                           if tags[sel.screen][i] then
                               awful.client.movetotag(tags[sel.screen][i])
                           end
                       end
                   end))
    table.insert(globalkeys, key(k_ma, i,
                   function ()
                       local sel = client.focus
                       if sel then
                           if tags[sel.screen][i] then
                               awful.client.toggletag(tags[sel.screen][i])
                           end
                       end
                   end))
end

---- }}}

root.keys(globalkeys)

-- {{{ Hooks

awful.hooks.focus.register(function(c)
    -- Set border to active color
    c.border_color = beautiful.border_focus 

end)

-- Hook function to execute when unfocusing a client.
awful.hooks.unfocus.register(function(c)
    c.border_color = beautiful.border_normal
end)

awful.hooks.mouse_enter.register(function(c)
   -- Set focus for sloppy focus
   if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and 
      awful.client.focus.filter(c) then 
       client.focus = c
   end
end)

function match_tag(c, class, rule)
    --io.stderr:write("matching: "..c.class.."\n")
    if c.class:lower():find(class) then  
         for s = 1, screen.count() do
             for i = 1, #tags[s] do
                 --io.stderr:write(tags[s][i].name:lower():find(rule[1]).."\n")
                if s == rule[1] and tags[s][i].name:lower():find(rule[2]) then
                    c.screen = s
                    awful.client.movetotag(tags[s][i], c)
                    --io.stderr:write("match: "..c.class.."/"..class.." / "..s.."\n")
                    return 1
                end
             end  
         end
    else
        return 0
     end
end


awful.hooks.manage.register(function(c, startup)
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end
    -- Create border
    if not c.class:lower():find("rxvt") then
        c.border_width = beautiful.border_width
    else
        c.border_width = 0
    end
    c.border_color = beautiful.border_focus 

    -- Add mouse bindings
    -- Mod+Button1: Move window
    c:buttons({
        button(k_m, 1, function (c) awful.mouse.client.move() end),
        button(k_n, 1, function (c) client.focus = c; c:raise() end),
        button(k_m, 3, function (c) awful.mouse.client.resize() end)
    })

    -- Add a titlebar
    if use_titlebar and not c.class:lower():find('mplayer') then
        awful.titlebar.add(c, { modkey = modkey })
    end 
    
    -- Set tag rules
    for class,rule in pairs(tag_rules) do  
        match_tag(c, class, rule)
    end  
    
    -- Float
    c.floating_placement = "smart"
    for i, class in ipairs(floating_rules) do  
        if c.class:lower():find(class) then  
            awful.client.floating.set(c, true) 
        end  
    end

    -- Transparency
    for class,trans in pairs(trans_rules) do
        if c.class:lower():find(class) then
            c.opacity = trans
        end
    end
    
    -- Focus new clients
    if c.screen == mouse.screen then
        client.focus = c
    end

    --honor size hints, but only for mplayer :)
    if c.class:lower():find('mplayer') then
        c.size_hints_honor = true
    else
        c.size_hints_honor = false
    end
    
    -- Prevents new windows from becoming master
    awful.client.setslave(c)
end)                 


awful.hooks.arrange.register(function(screen)
    local layout = awful.layout.getname(awful.layout.get(screen))
    if layout then
        mylayoutbox[screen].image = image(beautiful["layout_" .. layout])
    else
        mylayoutbox[screen].image = nil
    end

    -- Check focus
    if not client.focus then
        local c = awful.client.focus.history.get(screen, 0)
        if c then client.focus = c end
    end
end)

-- }}}
