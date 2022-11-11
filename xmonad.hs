------------------------------------------------------------------------
------------------------------------------------------------------------
--------------------------- XMONAD CONFIG ------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------



------------------------------ CONTENT ---------------------------------
--  1. Imports
--  2. Variables
--  3. Desktop notifications
--  4. Key bindings
--  5. Mouse bindings
--  6. Layouts
--  7. Window rules
--  8. Event Handling
--  9. Status bar and logging
--  10.Startup hook
--  11.Main
--  12.Default bindings
------------------------------------------------------------------------



------------------------------------------------------------------------
-- 1. IMPORTS
------------------------------------------------------------------------

-- main
import XMonad hiding ( (|||) ) -- jump to layout
import XMonad.Layout.LayoutCombinators (JumpToLayout(..), (|||)) -- jump to layout
import XMonad.Config.Desktop
import qualified XMonad.StackSet as W
import XMonad.Operations
import Control.Monad

-- data
import Data.Char (isSpace)
import Data.List
import Data.Monoid
import Data.Maybe (isJust)
import Data.Ratio ((%)) -- for video
import qualified Data.Map as M

-- system
import System.IO (hPutStrLn) -- for xmobar
import System.Exit

-- util
import XMonad.Util.Dmenu
import XMonad.Util.Run (safeSpawn, unsafeSpawn, runInTerm, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeysP, additionalMouseBindings)  
import XMonad.Util.NamedScratchpad
import XMonad.Util.NamedWindows
import XMonad.Util.WorkspaceCompare
import XMonad.Util.NamedActions

-- hooks
import XMonad.ManageHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks 
import XMonad.Hooks.EwmhDesktops -- to show workspaces in application switchers
import XMonad.Hooks.ManageHelpers 
import XMonad.Hooks.Place (placeHook, withGaps, smart)
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.ServerMode


-- actions
import XMonad.Actions.CopyWindow -- for dwm window style tagging
import XMonad.Actions.UpdatePointer -- update mouse postion
import XMonad.Actions.MouseResize
import XMonad.Actions.CycleWS as C
import XMonad.Actions.Promote

-- layout 
import XMonad.Layout.Accordion
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.GridVariants
import XMonad.Layout.ResizableTile
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.LimitWindows
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.MultiToggle
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Gaps
import XMonad.Layout.WindowArranger
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))


------------------------------------------------------------------------
-- 2. Variables
------------------------------------------------------------------------

myTerminal      = "alacritty"
myTextEditor    = "vim"
myFileManager	= "nemo"
myBrowser 	= "chromium"
myCalculator = "qalculate-gtk"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False
myClickJustFocuses :: Bool
myClickJustFocuses = False
myBorderWidth   = 1
myNormalBorderColor  = "#111111"
--myNormalBorderColor  = "#404040"
-- myNormalBorderColor  = "#405362"
myFocusedBorderColor = "#777777"
--myFocusedBorderColor = "#ffffff"
--myFocusedBorderColor = "#000000"
myModMask       = mod4Mask

myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
--myWorkspaces    = ["1","2","3","4","5","6","7"]

-- xmobar colors
myppCurrent = "#5ACCFF"
myppVisible = "#bb4fff"
myppHidden = "#999999"
myppHiddenNoWindows = "#646464"
--myppTitle = "#F2EEE2"
myppTitle = "#ABABAB"
myppUrgent = "#F8B0000"
myppExtras = "#54CCFF"

windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
--windowCount2 = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
--DC322F

------------------------------------------------------------------------
-- 3. Desktop notifications -- (dunst package)
------------------------------------------------------------------------

data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        Just idx <- fmap (W.findTag w) $ gets windowset

        safeSpawn "notify-send" [show name, "workspace " ++ idx]

------------------------------------------------------------------------
-- 4. Key bindings
------------------------------------------------------------------------

myKeys = [ ("M-<Return>", spawn (myTerminal))
    -- SPAWN SHORTCUTS
	  ,("M-p",                    spawn "dmenu_run -l 15")
	  ,("M-e",                    spawn (myFileManager))
    ,("M-S-e",                  spawn "nemo Downloads/0-shots")
	  ,("M-v",                    spawn "copyq toggle")
	  ,("M-b",                    spawn (myBrowser))
	  ,("M-a",                    spawn (myCalculator))
    ,("M-o",                    spawn "obsidian")
	  ,("M-S-t",                  spawn (myTerminal ++ " -e btop"))

    -- SCREENSHOT SHORTCUTS
	  ,("<Print>",                spawn "flameshot gui -c -p ~/Downloads/0captures/")
	  ,("M-<Print>",              spawn "flameshot full -c -p ~/Downloads/0captures/")
	  ,("M-S-<Print>",            spawn "flameshot gui")
	  ,("M-M1-<Print>",           spawn "flameshot screen -c -p ~/Downloads/0captures/")

    -- SYSTEM AND XMONAD SHORTCUTS
    ,("C-M-M1-q",               spawn "systemctl poweroff")

    -- FUNCTION SHORTCUTS
	  ,("<XF86MonBrightnessUp>",  spawn "brightnessctl set +15")
	  ,("<XF86MonBrightnessDown>",spawn "brightnessctl set 15-")
    ,("<XF86AudioMute>",        spawn "amixer set Master toggle")
    ,("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
    ,("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")


    --	  ,("M-t",                    spawn (myTerminal ++ "cmatrix -ms"))
    --    ,("<XF86AudioPlay>",        spawn "mocp --play")
    --	  ,("C-M-S-s",                spawn "./.xmonad/lock.sh")
    --	  ,("M-S-v",        spawn "copyq menu")
    --	  ,("<Print>",    spawn "maim -s | xclip -selection clipboard -t image/png")
    --	  ,("<Print>",    spawn "scrot -s '/tmp/%F-%T-$wx$h.png' -e 'xclip -selection clipboard -t image/png -i $f'")
    --,("M-f",       sendMessage (MT.Toggle FULL))
	  --,("<KP_F7>", spawn " brillo -U 5")
    --,("<xF86XK_AudioMute>", spawn "amixer -q set Master toggle")
    --, ("<XF86AudioNext>", spawn "mocp --next")
    --, ("<XF86AudioPrev>", spawn "mocp --previous")
    ]

myScratchpads :: [NamedScratchpad]
myScratchpads = [alacritty]
  where
    alacritty = NS "alacritty" spawn find manage
      where
        spawn  = myTerminal ++ " -t term"
        find   = title =? "term"
        manage = customFloating $ rectCentered 0.45

openScratchPad :: String -> X ()
openScratchPad = namedScratchpadAction myScratchpads

rectCentered :: Rational -> W.RationalRect
rectCentered percentage = W.RationalRect offset offset percentage percentage
  where
    offset = (1 - percentage) / 2


vertRectCentered :: Rational -> W.RationalRect
vertRectCentered height = W.RationalRect offsetX offsetY width height
  where
    width = height / 2
    offsetX = (1 - width) / 2
    offsetY = (1 - height) / 2


------------------------------------------------------------------------
-- 5. Mouse bindings: default actions bound to mouse events
------------------------------------------------------------------------

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- 6. Layouts:
------------------------------------------------------------------------

--myLayout = avoidStruts (tiled ||| grid ||| bsp ||| full) ||| full
myLayout = avoidStruts (grid_t ||| tiled ||| grid_s ||| mono) ||| full
  where
     
    -- mono
     mono = renamed [Replace "mono"] 
          $ noBorders (Full)   
    
    -- full  
     full = renamed [Replace "full"] 
          $ noBorders (Full)

    -- tiled
     tiled = renamed [Replace "tiled"] 
    --      $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True 
           $ spacingRaw True (Border 0 0 0 0) True (Border 0 0 0 0) True 
           $ ResizableTall 1 (3/100) (1/2) []

    -- grid_t
     grid_t = renamed [Replace "grid_t"] 
          $ noBorders
          $ spacingRaw True (Border 0 0 0 0) True (Border 0 0 0 0) True 
          $ Grid (16/10)

    -- grid_s
     grid_s = renamed [Replace "grid_s"] 
          $ spacingRaw True (Border 100 0 100 0) True (Border 0 100 0 100) True 
          $ Grid (16/10)


     base = renamed [Replace "base"] 
          $ spacingRaw True (Border 0 0 0 0) True (Border 0 0 0 0) True 
          $ Grid (16/10)


     -- bsp
     bsp = renamed [Replace "bsp"] 
         $ emptyBSP

     -- The default number of windows in the master pane
     nmaster = 1
     
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- 7. Window rules:
------------------------------------------------------------------------

myManageHook = composeAll
    [ className =? "mpv"            --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , className =? "copyq"            --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , className =? "pavucontrol"            --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , className =? myCalculator            --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
--    , className =? "pavucontrol"    --> doCenterFloat
    --, className =? "pavucontrol"    --> doCenterFloat
--    , className =? "Gimp"           --> doFloat
    , className =? "chromium" <&&> resource =? "Toolkit" --> doFloat -- firefox pip
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    , className =? "qt5ct"           --> doCenterFloat
    , className =? "nemo"         --> doCenterFloat
    , isFullscreen --> doFullFloat
    ] 

------------------------------------------------------------------------
-- 8. Event handling
------------------------------------------------------------------------

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
--myEventHook = mempty

------------------------------------------------------------------------
-- 9. Status bars and logging
------------------------------------------------------------------------

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook = return ()

------------------------------------------------------------------------
-- 10. Startup hook
------------------------------------------------------------------------

myStartupHook :: X ()
myStartupHook = do
        traverse spawnOnce
          [
--          "./bin/screenlayout/<tocomplete>"
            "xsetroot -cursor_name left_ptr"
          , "picom &"
          , "nitrogen --restore &"
          , "lxsession"
    	    , "dunst &"
          , "copyq &"
          , "zsh &"
          ]
	setWMName "Xmonad Pro Plus Max Ultra Premium"

------------------------------------------------------------------------
-- 11. MAIN
------------------------------------------------------------------------

main = do
    xmproc0 <- spawnPipe "xmobar -x 0 /home/neo/.config/xmobar/xmobarrc0.hs"
    xmproc1 <- spawnPipe "xmobar -x 1 /home/neo/.config/xmobar/xmobarrc0.hs"
    xmonad $ withUrgencyHook LibNotifyUrgencyHook $ ewmh (desktopConfig
        { manageHook = ( isFullscreen --> doFullFloat ) <+> manageDocks <+> myManageHook <+> manageHook desktopConfig
        , startupHook        = myStartupHook
        , layoutHook         = myLayout
        , handleEventHook    = handleEventHook desktopConfig
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , terminal           = myTerminal
        , modMask            = myModMask
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , logHook = dynamicLogWithPP xmobarPP  
                       { ppOutput = \x -> hPutStrLn xmproc0 x >> hPutStrLn xmproc1 x
--                        { ppOutput = \x -> hPutStrLn xmproc0 x
                        , ppCurrent = xmobarColor myppCurrent ""  -- Current workspace in xmobar
                        , ppVisible = xmobarColor myppVisible ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor myppHidden "" -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor  myppHiddenNoWindows ""        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor  myppTitle "" . shorten 80     -- Title of active window in xmobar
                        , ppSep =  "<fc=#586E75> </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor  myppUrgent "" . wrap "!" "!"  -- Urgent workspace
--                        , ppExtras  = [windowCount, windowCount2]                           -- # of windows current workspace
                        , ppExtras  = [windowCount]   -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        } >> updatePointer (0.25, 0.25) (0.25, 0.25)
          }) `additionalKeysP` myKeys


------------------------------------------------------------------------
-- 12. Default bindings - to handle errors
------------------------------------------------------------------------

help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]

