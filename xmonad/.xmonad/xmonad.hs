import XMonad
import XMonad.Config

import XMonad.Hooks.EwmhDesktops

import qualified XMonad.Hooks.ManageDocks as ManageDocks
import qualified XMonad.Hooks.SetWMName as SetWMName
import qualified XMonad.Config.Gnome as Gnome
import qualified XMonad.StackSet as W
import qualified XMonad.Layout.WindowNavigation as WindowNavigation

import qualified Data.Map as Map
import Data.List

import XMonad.Hooks.FloatNext

main = xmonad $ Gnome.gnomeConfig
--main = xmonad $ defaultConfig
    { workspaces         = workspaces'
    , borderWidth        = 1
    , normalBorderColor  = "#cccccc"
    , focusedBorderColor = "#cd8b00"
    , manageHook         = myManageHook
    , layoutHook         = myLayoutHook
    , logHook            = myLogHook
    , terminal           = "gnome-terminal --hide-menubar"
    , modMask            = defaultModMask
    , startupHook        = SetWMName.setWMName "LG3D"
    , keys               = \c -> myKeys c `Map.union` keys defaultConfig c
    }                                                      
--    , defaultGaps        = [(24,0,0,0)]

-- The key to use as the base key for XMonad-specific 
-- functions (change layout, etc.).
defaultModMask :: KeyMask
-- defaultModMask = mod3Mask -- Right Alt
defaultModMask = mod1Mask -- Left Alt
-- defaultModMask = mod4Mask -- Windows "Start Key"
-- defaultModMask = 115      -- Windows start button

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--

-- myManageHook = floatNextHook <+> manageHook defaultConfig
myManageHook = composeAll . concat $
   [ [ManageDocks.manageDocks]
   , [floatNextHook <+> manageHook defaultConfig]
   , [manageHook Gnome.gnomeConfig]
   , [className =? "Firefox-bin"     --> doShift "2"]
   , [className =? "Firefox"         --> doShift "2"]
   , [className =? "Minefield"       --> doShift "2"]
   , [(className =? "Firefox" <&&> resource =? "Dialog") --> doFloat]
   , [className =? "Thunderbird"     --> doShift "3"]
   , [className =? "Thunderbird-bin" --> doShift "3"]
   , [title =? "Chandler"            --> doShift "3"]
   , [className =? "Xchat"           --> doShift "4"]
   , [className =? "keepassx"        --> doShift "4"]
--   , [className =? "Variations"      --> doFloat]
--   , [className =? "variations"      --> doFloat]
--   , [className =? "Toplevel"      --> doFloat]
--   , [title =? "Variations"      --> doFloat]
--   , [title =? "variations"      --> doFloat]
--   , [title =? "topLevel"      --> doFloat]
   , [title     =? "Azureus"         --> doShift "9"]
     -- using list comprehensions and partial matches
   , [ className =?  c --> doFloat | c <- myFloatsC ]
   , [ title     =?  c --> doFloat | c <- myFloatsT ]
   , [ fmap ( c `isInfixOf`) className --> doFloat | c <- myMatchAnywhereFloatsC ]
   , [ fmap ( c `isInfixOf`) title     --> doFloat | c <- myMatchAnywhereFloatsT ]
   ]
   -- in a composeAll hook, you'd use: fmap ("VLC" `isInfixOf`) title --> doFloat
  where myFloatsC = ["MPlayer", "jx-frames-J", "Hback", "Flicker", "Gimp", "gimp",
                      "Deskbar-applet", "processing-app-base", "sun-awt-X11-XFramePeer",
                      "org-eclipse-osgi-framework-eventmgr-EventManager$EventThread",
                      "search", "QuickNote", "Firefox"]
        -- Toolbox is gimp,
        myFloatsT = ["Toolbox", "glade-3", "Save a Bookmark", "Variations", "phalanx"]
        myMatchAnywhereFloatsC = ["Google", "Pidgin", "Best Tree Games"]
        myMatchAnywhereFloatsT = ["treeGraph", "treeBest", "Scid"]

-- unused now, after switching to above; keeping for a while just in case need to revert
myManageHook2 = composeAll
    [ ManageDocks.manageDocks
    , manageHook Gnome.gnomeConfig
    , resource  =? "desktop_window"  --> doIgnore
    , resource  =? "kdesktop"        --> doIgnore
    , className =? "MPlayer"         --> doFloat
    , className =? "jx-frames-J"     --> doFloat
    , className =? "Hback"           --> doFloat
    , className =? "Flicker"         --> doFloat
    , className =? "Gimp"            --> doFloat -- gimp
    , className =? "gimp"            --> doFloat -- gimp
    , title =? "Toolbox"            --> doFloat  -- gimp
    , title     =? "Saved Passwords" --> doFloat
    , className =? "Deskbar-applet"  --> doFloat
    , className =? "Firefox-bin"     --> doF (W.shift "2")
    , className =? "Firefox"         --> doF (W.shift "2")
    , className =? "Minefield"       --> doF (W.shift "2")
    , className =? "Thunderbird"     --> doF (W.shift "3")
    , className =? "Thunderbird-bin" --> doF (W.shift "3")
    , title     =? "Chandler"        --> doF (W.shift "3")
    , className =? "Xchat"           --> doF (W.shift "4")
    , className =? "keepassx"        --> doF (W.shift "4")
    , title     =? "Azureus "        --> doF (W.shift "6") 
    , title     =? "glade-3"         --> doFloat
    , className =? "processing-app-Base" --> doFloat
    , className =? "sun-awt-X11-XFramePeer" --> doFloat
    , className =? "org-eclipse-osgi-framework-eventmgr-EventManager$EventThread" --> doFloat
    , className =? "search"          --> doFloat
    , className =? "QuickNote" --> doFloat
    , title     =? "Save a Bookmark" --> doFloat
    , title     =? "Scid: Replace move?" --> doFloat
    ]
--manageHook w "Top Expanded Edge Panel" "gnome-panel" _ = reveal w >> return (W.delete w)

workspaces' = map show $ [1 .. 9 :: Int] ++ [0]

-- Status bars and logging
 
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
-- Following is default:
--myLogHook = return ()
-- Following is for Gnome, but wasn't working for other reasons
myLogHook :: X ()
myLogHook = ewmhDesktopsLogHook

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayoutHook = ManageDocks.avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
 
     -- The default number of windows in the master pane
     nmaster = 1
 
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
 
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

--myLayoutHook2 = ewmhDesktopsLayout $ ManageDocks.avoidStruts $ layoutHook Gnome.gnomeConfig

--noFollow CrossingEvent {} = return False
--noFollow _                = return True

-- Window rules:

 
-- Whether focus follows the mouse pointer.
--myFocusFollowsMouse :: Bool
--myFocusFollowsMouse = False

myKeys (XConfig {modMask = modm}) = Map.fromList $
                -- Apps and tools
                [ 
                ((modm .|. shiftMask, xK_s), spawn "gnome-search-tool")
                , ((modm, xK_End), spawn "gnome-session-save --kill")
                         
                -- Special commands
                , ((modm, xK_F11 ),  spawn "xlock")
                -- shift-alt-e to float next spawned window
                , ((modm .|. shiftMask, xK_e), toggleFloatNext)
                -- shift-alt-r to float all spawned windows until disabled again
                , ((modm .|. shiftMask, xK_r), toggleFloatAllNew)

                ,((modm .|. shiftMask, xK_b), sendMessage ManageDocks.ToggleStruts)

                ]

