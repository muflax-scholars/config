------------
-- Import --
------------
-- basic imports
import Data.Monoid
import Data.Ratio ((%))
import System.Exit
import System.IO
import XMonad
import qualified Data.Map        as M
import qualified XMonad.StackSet as W

-- actions
import XMonad.Actions.CycleWS
import XMonad.Actions.NoBorders
import qualified XMonad.Actions.ConstrainedResize as Sqr
import qualified XMonad.Actions.FlexibleResize    as FlexMouse

-- hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook

-- layouts
import XMonad.Layout.GridVariants
import XMonad.Layout.IM
import XMonad.Layout.LayoutHints
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.Reflect               
import XMonad.Layout.ResizableTile
import XMonad.Layout.StackTile

-- utils
import XMonad.Util.Run

------------------
-- Basic Config --
------------------

-- The preferred terminal program.
terminal' = "urxvt"

-- Whether focus follows the mouse pointer.
focusFollowsMouse' = True

-- Width of the window border in pixels.
borderWidth' = 3

-- modMask lets you specify which modkey you want to use.
modMask' = mod4Mask

-- Pre-defined workspaces.
workspaces' = ["1:tty", "2:toile"] ++ map show [3..7] ++ ["8:暗愚蛮努", "9:会話"]

-- Pretty stuff
font'               = "-*-gothic-medium-*-12-*"
normalBorderColor'  = "#000000"
focusedBorderColor' = "#aa5500"

-- dmenu
dmenu'     = "dmenu -b -i -fn '"++font'++"' -nb '#000000' -nf '#FFFFFF' -sb '"++focusedBorderColor'++"'"
dmenuPath' = "exe= `dmenu_path | "++dmenu'++"` && eval \"exec $exe\""

-------------------
-- Key bindings. --
-------------------
keys' conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_p     ), spawn $ XMonad.terminal conf)
    -- launch dmenu
    , ((modm,               xK_e     ), spawn dmenuPath')
    -- close focused window
    , ((modm .|. shiftMask, xK_w     ), kill)
    -- Rotate through the available layout algorithms
    , ((modm,               xK_space ) , sendMessage NextLayout)
    -- reset layouts
    , ((modm .|. shiftMask, xK_space ) , setLayout $ XMonad.layoutHook conf)
    -- tile again
    , ((modm .|. controlMask, xK_space ) , withFocused $ windows . W.sink)
    
    -- focus movement
    , ((modm,               xK_n     ), windows W.focusUp )
    , ((modm,               xK_r     ), windows W.focusDown )
    , ((modm,               xK_s     ), windows W.focusMaster )
    -- swap based on focus
    , ((modm .|. shiftMask, xK_n     ), windows W.swapUp )
    , ((modm .|. shiftMask, xK_r     ), windows W.swapDown )
    , ((modm .|. shiftMask, xK_s     ), windows W.swapMaster )
    -- resize
    , ((modm,               xK_t     ), sendMessage (IncMasterN 1) )
    , ((modm .|. shiftMask, xK_t     ), sendMessage (IncMasterN (-1)) )
    , ((modm .|. controlMask, xK_n   ), sendMessage Expand )
    , ((modm .|. controlMask, xK_r   ), sendMessage Shrink )
    , ((modm .|. controlMask, xK_t   ), sendMessage MirrorExpand )
    , ((modm .|. controlMask, xK_s   ), sendMessage MirrorShrink )
    
    -- toggles
    , ((modm,               xK_f     ), sendMessage $ Toggle NBFULL )
    , ((modm,               xK_y     ), sendMessage $ Toggle REFLECTX )
    , ((modm .|. shiftMask, xK_y     ), sendMessage $ Toggle REFLECTY )
    , ((modm,               xK_m     ), sendMessage $ Toggle MIRROR )
    , ((modm,               xK_b     ), sendMessage $ Toggle NOBORDERS )
    
    -- prev / next workspace
    , ((modm,               xK_h     ), moveTo Next HiddenNonEmptyWS )
    , ((modm .|. shiftMask, xK_h     ), moveTo Prev HiddenNonEmptyWS )
    -- next screen
    , ((modm,               xK_g     ), nextScreen  )
    -- swap screens
    , ((modm .|. shiftMask, xK_g     ), swapNextScreen  )

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    -- Restart xmonad
    , ((modm              , xK_q     ), 
        spawn "xmonad --recompile; xmonad --restart")
    
    -- Volume Control
    , ((0                 , 0x1008ff11), -- XF86AudioLowerVolume 
        safeSpawn "ossmix" ["vmix0-outvol", "-q", "--", "-1"])
    , ((shiftMask         , 0x1008ff11), -- S-XF86AudioLowerVolume 
        safeSpawn "ossmix" ["vmix0-outvol", "-q", "--", "+1"])
    , ((modm              , 0x1008ff11), -- M-XF86AudioLowerVolume 
        spawn "ssh amon@azathoth -- ossmix vmix0-outvol -q -- -1")
    , ((modm .|. shiftMask, 0x1008ff11), -- M-S-XF86AudioLowerVolume 
        spawn "ssh amon@azathoth -- ossmix vmix0-outvol -q -- +1")
    
    -- mpc
    , ((modm              , xK_c     ), 
        spawn "MPD_HOST=192.168.1.15 mpc --no-status toggle")
    
    -- screenshots
    , ((modm .|. shiftMask, xK_o     ), 
        spawn "$HOME/local/src/in/randomstuff/selection")
    
    -- yes, those are hardcoded positions... so what?
    , ((modm .|. controlMask, xK_1     ), 
        spawn "DISPLAY=:0.1 swarp 640 512")
    , ((modm .|. controlMask, xK_2     ), 
        spawn "DISPLAY=:0.0 swarp 840 525")

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
    , ((modm, button3),               (\w -> focus w >> FlexMouse.mouseResizeWindow w))
    , ((modm .|. shiftMask, button3), (\w -> focus w >> Sqr.mouseResizeWindow w True ))


    ]

-------------
-- Layouts --
-------------

layout' = 
    -- global modifiers
    avoidStruts $            -- don't overlap docks
    
    mkToggle1 NBFULL    $    -- toggles
    mkToggle1 REFLECTX  $
    mkToggle1 REFLECTY  $
    mkToggle1 NOBORDERS $
    mkToggle1 MIRROR    $

    (tiled ||| grid ||| stack ||| full)
    where
         -- normal tiling
         tiled      = named "瓦" $
                      hinted     $
                      pidgin     $
                      ResizableTall nmaster delta ratio slaves
         -- grid for terminals or chats
         grid       = named "格子" $
                      hinted       $
                      pidgin       $
                      Grid (16/10)
         -- stacked for many open windows
         stack      = named "皿" $
                      StackTile nmaster delta stackRatio
         -- fullscreen
         full       = named "全"    $
                      gimp          $
                      smartBorders  $
                      Full

         -- treat buddy list dock-like
         pidgin l   = withIM (1%7) (Role "buddy_list") l
         -- experimental gimp handling :)
         gimp   l   = withIM (0.11) (Role "gimp-toolbox") $
                      reflectHoriz                        $
                      withIM (0.15) (Role "gimp-dock")    $
                      reflectHoriz l
         -- take care of terminal size
         hinted l   = layoutHintsWithPlacement( 0.5, 0.5) l
                      
         -- The default number of windows in the master pane
         nmaster    = 1
         -- Default proportion of screen occupied by master pane
         ratio      = 1/2
         -- dito when stacked
         stackRatio = 3/4
         -- Percent of screen to increment by when resizing panes
         delta      = 3/100
         -- fraction to multiply the window height that would be given when
         -- divided equally 
         slaves     = []

-----------
-- Hooks --
-----------
-- Window handling
manageHook' = composeAll $
        -- auto-float
        [ className =? c --> doCenterFloat | c <- floats' ]
        ++
        [ className =? "Pidgin"  --> doShift "9:会話"
        , className =? "Firefox" --> doShift "2:toile"
        , className =? "Angband" --> doShift "8:暗愚蛮努"
        ]
        ++
        [ className =? "MPlayer" --> doIgnore] -- FIXME: ugly, but good enough 
                                               --        for now...
                                               --        this should probably
                                               --        be a separate WS...
    where floats'      = [ "Wine" 
                         , "Angband"
                         , "Gxmessage"
                         ]
    
-- Status bars and logging
customPP = defaultPP {
              ppCurrent = dzenColor "" focusedBorderColor' . wrap " " " "
            , ppVisible = dzenColor "" "" . wrap "(" ")"
            , ppUrgent  = dzenColor "" "#ff0000" . wrap "*" "*" . dzenStrip
            , ppWsSep   = dzenColor "" "" " "
            --, ppOrder   = \(ws:l:_:_) -> [ws, l] -- show workspaces and layout
            , ppOrder   = \(ws:l:t:_) -> [ws,l,shorten 30 t] -- show workspaces and layout
          }
logHook' = dynamicLogWithPP $ customPP

-- Urgency
urgencyHook' = withUrgencyHook NoUrgencyHook

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
            logHook            = logHook'
            --startupHook        = adjustEventInput, -- mouse focus
            --handleEventHook    = focusOnMouseMove
        }
