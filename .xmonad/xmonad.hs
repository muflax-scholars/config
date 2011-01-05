------------
-- Import --
------------
-- basic imports
import Data.Monoid
import Data.Ratio ((%))
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
import XMonad.Layout.Cross
import XMonad.Layout.GridVariants hiding (L, R)
import XMonad.Layout.IM
import XMonad.Layout.LayoutHints
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect               
import XMonad.Layout.ResizableTile
import XMonad.Layout.StackTile
import XMonad.Layout.WindowNavigation

-- utils
import XMonad.Util.WorkspaceCompare (getSortByIndex)
import XMonad.Util.Run
import XMonad.Util.Scratchpad

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
workspaces' = [ "tty"   -- main control stuff
              , "hack"  -- programming stuff
              , "暗記"  -- anki
              , "txt"   -- books
              , "研究"  -- current study topic
              , "勉強"  -- uni stuff
              , "eat"   -- }
              , "pray"  -- } dummy ws
              , "love"  -- }
              , "toile" -- web
              ] 

-- Pretty stuff
font'               = "-mplus-gothic-medium-r*12"
normalBorderColor'  = "#000000"
focusedBorderColor' = "#aa5500"

-- dmenu
dmenu'     = "dmenu -b -i -fn '"++font'++"' -nb '#000000' -nf '#FFFFFF' -sb '"++focusedBorderColor'++"'"
dmenuPath' = "exe= `dmenu_path | "++dmenu'++"` && eval \"exec $exe\""
dmenuQuick' = "exe= `cat $HOME/.programs | "++dmenu'++"` && eval \"exec $exe\""

-------------------
-- Key bindings. --
-------------------
keys' conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm,               xK_u     ), spawn $ XMonad.terminal conf)
    -- launch scratchpad
    , ((modm,               xK_i     ), scratchpad)
    -- launch dmenu
    , ((modm,               xK_e     ), spawn dmenuQuick')
    , ((modm,               xK_o     ), spawn dmenuPath')
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
    , ((modm,               xK_s     ), sendMessage $ Go L )
    , ((modm,               xK_t     ), sendMessage $ Go R )
    -- swap based on focus
    , ((modm .|. shiftMask, xK_n     ), windows W.swapUp )
    , ((modm .|. shiftMask, xK_r     ), windows W.swapDown )
    , ((modm .|. shiftMask, xK_s     ), sendMessage $ Swap L )
    , ((modm .|. shiftMask, xK_t     ), sendMessage $ Swap R )
    -- resize
    , ((modm,               xK_d     ), sendMessage (IncMasterN 1) )
    , ((modm .|. shiftMask, xK_d     ), sendMessage (IncMasterN (-1)) )
    , ((modm .|. controlMask, xK_r   ), sendMessage Expand )
    , ((modm .|. controlMask, xK_n   ), sendMessage Shrink )
    , ((modm .|. controlMask, xK_t   ), sendMessage MirrorExpand )
    , ((modm .|. controlMask, xK_s   ), sendMessage MirrorShrink )
    
    -- toggles
    , ((modm,               xK_f     ), sendMessage $ Toggle NBFULL )
    , ((modm,               xK_y     ), sendMessage $ Toggle REFLECTX )
    , ((modm .|. shiftMask, xK_y     ), sendMessage $ Toggle REFLECTY )
    , ((modm,               xK_m     ), sendMessage $ Toggle MIRROR )
    , ((modm,               xK_b     ), sendMessage $ Toggle NOBORDERS )
    
    -- prev / next workspace
    , ((modm,               xK_h     ), windows . W.greedyView =<< findWorkspace getSortByIndexNoSP Next HiddenNonEmptyWS 1)
    , ((modm .|. shiftMask, xK_h     ), windows . W.greedyView =<< findWorkspace getSortByIndexNoSP Prev HiddenNonEmptyWS 1)
    -- next screen
    , ((modm,               xK_g     ), nextScreen  )
    -- swap screens
    , ((modm .|. shiftMask, xK_g     ), swapNextScreen  )

    -- Restart xmonad
    , ((modm .|. shiftMask, xK_q     ), 
        spawn "xmonad --recompile && xmonad --restart")
    
    -- Volume Control
    , ((0                 , 0x1008ff11), -- XF86AudioLowerVolume 
        safeSpawn "amixer" ["set", "Master", "-q", "5-"])
    , ((shiftMask         , 0x1008ff11), -- S-XF86AudioLowerVolume 
        safeSpawn "amixer" ["set", "Master", "-q", "5+"])
    , ((modm              , 0x1008ff11), -- M-XF86AudioLowerVolume 
        spawn "ssh amon@azathoth -- amixer set Master -q 5-")
    , ((modm .|. shiftMask, 0x1008ff11), -- M-S-XF86AudioLowerVolume 
        spawn "ssh amon@azathoth -- amixer set Master -q 5+")
    
    -- mpc
    , ((modm              , xK_c     ), 
        spawn "MPD_HOST=192.168.1.15 mpc --no-status toggle")
    
    -- screenshots
    , ((modm .|. shiftMask, xK_o     ), 
        spawn "$HOME/local/src/in/randomstuff/selection")
    
    -- yes, those are hardcoded positions... so what?
    , ((modm .|. controlMask, xK_1     ), 
        spawn "left_display")
    , ((modm .|. controlMask, xK_2     ), 
        spawn "right_display")

    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

    where 
         getSortByIndexNoSP =
                fmap (.scratchpadFilterOutWorkspace) getSortByIndex


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

    -- workspace specific preferences
    onWorkspace "tty" (grid ||| tiled)            $
    onWorkspace "暗記" (grid ||| cross ||| tiled) $
    onWorkspace "toile" (tiled ||| grid)          $

    (grid ||| tiled ||| cross)
    where
         -- normal tiling
         tiled      = named "瓦"       $
                      hinted           $
                      windowNavigation $
                      pidgin           $
                      ResizableTall nmaster delta ratio slaves
         -- grid for terminals or chats
         grid       = named "格子"     $
                      hinted           $
                      windowNavigation $
                      pidgin           $
                      Grid (1/1)  
         -- cross to center one app, mostly anki
         cross      = named "十" $
                      Cross (2/3) (1/100)
         -- fullscreen
         full       = named "全"    $
                      smartBorders  $
                      Full

         -- treat buddy list dock-like
         pidgin l   = withIM (1%8) (Role "buddy_list") l
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
        [ className =? "Pidgin"  --> doShift "toile"
        , className =? "Firefox" --> doShift "toile"
        , className =? "claws-mail" --> doShift "toile"
        , className =? "Anki" --> doShift "暗記"
        ]
        ++
        [ className =? "MPlayer" --> doIgnore] -- FIXME: ugly, but good enough 
                                               --        for now...
                                               --        this should probably
                                               --        be a separate WS...
        ++
        [ isFullscreen --> doFullFloat ]
    where floats'      = [ "Wine" 
                         , "Gxmessage"
                         , "Gimp"
                         ]

-- Scratchpad terminal
manageScratchpad = scratchpadManageHook (W.RationalRect 0.25 0.25 0.5 0.5)
scratchpad = scratchpadSpawnActionCustom "urxvt -name scratchpad -e zsh -c 'screen -DRS scratchpad'"
{-scratchpad = scratchpadSpawnActionCustom $-}
	{-"emacs --name scratchpad ~/spoiler/scratchpad"-}
    
-- Status bars and logging
customPP = defaultPP {
              ppCurrent = dzenColor "" focusedBorderColor' . wrap " " " "
            , ppVisible = dzenColor "" "" . wrap "(" ")"
            , ppUrgent  = dzenColor "" "#ff0000" . wrap "*" "*" . dzenStrip
            , ppWsSep   = dzenColor "" "" " "
            , ppTitle   = shorten 80
            , ppOrder   = \(ws:l:t:_) -> [ws,l,t] -- show workspaces and layout
            {-, ppSort    = fmap (.scratchpadFilterOutWorkspace) $ ppSort defaultPP -}
          }

logHook' = dynamicLogWithPP customPP

-- Urgency
urgencyHook' = withUrgencyHookC NoUrgencyHook urgencyConfig {
                 suppressWhen = OnScreen
               , remindWhen   = Dont
               } 

-----------------------------------------------------
-- Now run xmonad with all the defaults we set up. --
-----------------------------------------------------
main = do
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
            manageHook         = manageHook' <+> manageScratchpad <+> manageDocks,
            logHook            = logHook'
        }
