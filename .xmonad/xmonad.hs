------------
-- Import --
------------
-- basic imports
import XMonad
import Data.Monoid
import System.Exit
import System.IO
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- actions
import qualified XMonad.Actions.ConstrainedResize as Sqr
import XMonad.Actions.CycleWS

-- hooks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

-- layouts
import XMonad.Layout.NoBorders

-- utils
import XMonad.Util.Run

------------------
-- Basic Config --
------------------

-- The preferred terminal program.
terminal'      = "urxvt"

-- Whether focus follows the mouse pointer.
focusFollowsMouse' :: Bool
focusFollowsMouse' = True

-- Width of the window border in pixels.
borderWidth'   = 3

-- modMask lets you specify which modkey you want to use.
modMask'       = mod4Mask

-- Pre-defined workspaces.
workspaces'    = ["1","2","3","4","5","6","7","8","9"]

-- Pretty stuff
font' = "-*-gothic-medium-*-12-*"
normalBorderColor'  = "#000055"
focusedBorderColor' = "#3465a4"

-- dmenu
dmenu' = "dmenu -b -i -fn '"++font'++"' -nb '#000000' -nf '#FFFFFF' -sb '#0066ff'"
dmenuPath' = "exe=`dmenu_path | "++dmenu'++"` && eval \"exec $exe\""

-------------------
-- Key bindings. --
-------------------
keys' conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_p     ), spawn $ XMonad.terminal conf)
    -- launch dmenu
    , ((modm,               xK_e     ), spawn dmenuPath')
    -- close focused window
    , ((modm,               xK_w     ), kill)
     -- Rotate through the available layout algorithms
    , ((modm .|. shiftMask, xK_space ), sendMessage NextLayout)
    -- TODO: temporarily :)
    , ((modm,               xK_space ), setLayout $ XMonad.layoutHook conf)
    -- Move focus to the next window
    , ((modm,               xK_n     ), windows W.focusDown)
    -- Move focus to the previous window
    , ((modm,               xK_r     ), windows W.focusUp  )
    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_n     ), windows W.swapDown  )
    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_r     ), windows W.swapUp    )
    -- prev / next workspace
    , ((modm,               xK_h     ), moveTo Prev HiddenNonEmptyWS )
    , ((modm,               xK_g     ), moveTo Next HiddenNonEmptyWS )
    -- next screen
    , ((modm .|. shiftMask, xK_h     ), nextScreen  )
    -- swap screens
    , ((modm .|. shiftMask, xK_g     ), swapNextScreen  )

    -- Shrink the master area
--    , ((modm .|. shiftMask, xK_h     ), sendMessage Shrink)
    -- Expand the master area
--    , ((modm .|. shiftMask, xK_g     ), sendMessage Expand)
    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    -- Volume Control
    , ((0                 , 0x1008ff11), -- XF86AudioLowerVolume 
        safeSpawn "ossmix" ["vmix0-outvol", "-q", "--", "-1"])
    , ((shiftMask         , 0x1008ff11), -- S-XF86AudioLowerVolume 
        safeSpawn "ossmix" ["vmix0-outvol", "-q", "--", "+1"])
    , ((modm              , xK_c     ), 
        spawn "MPD_HOST=192.168.1.15 mpc --no-status toggle")
    -- yes, those are hardcoded positions... so what?
    , ((modm              , xK_1     ), 
        spawn "DISPLAY=:0.0 swarp 840 525")
    , ((modm              , xK_2     ), 
        spawn "DISPLAY=:0.1 swarp 640 512")
    , ((modm .|. shiftMask, xK_o     ), 
        spawn "$HOME/src/in/randomstuff/selection")

    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


-----------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events --
-----------------------------------------------------------
mouseBindings' (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Resize (shift keeps the ratio constant)
    , ((modm, button3),               (\w -> focus w >> Sqr.mouseResizeWindow w False))
    , ((modm .|. shiftMask, button3), (\w -> focus w >> Sqr.mouseResizeWindow w True ))


    ]

-------------
-- Layouts --
-------------
layout' = avoidStruts $ (tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

-----------
-- Hooks --
-----------
-- Window rules
manageHook' = composeAll [ 
    className =? "MPlayer"        --> doFloat,
    className =? "Wine"           --> doFloat,
    className =? "Gimp"           --> doFloat
    ]

-- Event handling
eventHook' = mempty

-- Status bars and logging
customPP = defaultPP {
              ppCurrent = dzenColor "" focusedBorderColor' . wrap " " " "
            , ppVisible = dzenColor "" "" . wrap "(" ")"
            , ppUrgent  = dzenColor "" "#ff0000" . wrap "*" "*" . dzenStrip
            , ppWsSep   = dzenColor "" "" " "
            --, ppOrder   = \(ws:_:_:_) -> [ws]    -- show only workspaces
            , ppOrder   = \(ws:l:_:_) -> [ws, l] -- show workspaces and layout
          }
logHook' = dynamicLogWithPP $ customPP

-- Startup
startupHook' = return ()

-- Urgency
urgencyHook' = withUrgencyHook NoUrgencyHook -- TODO: actually handle it

-----------------------------------------------------
-- Now run xmonad with all the defaults we set up. --
-----------------------------------------------------
main = do
        --xmproc <- spawnPipe "xmobar" -- start xmobar
        xmonad $ urgencyHook' $ defaultConfig {
            -- simple stuff
            terminal           = terminal',
            focusFollowsMouse  = focusFollowsMouse',
            borderWidth        = borderWidth',
            modMask            = modMask',
            workspaces         = workspaces',
            normalBorderColor  = normalBorderColor',
            focusedBorderColor = focusedBorderColor',

            -- key bindings
            keys               = keys',
            mouseBindings      = mouseBindings',

            -- hooks, layouts
            layoutHook         = layout',
            manageHook         = manageHook' <+> manageDocks,
            handleEventHook    = eventHook',
            logHook            = logHook',
            startupHook        = startupHook'
        }
