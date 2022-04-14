import XMonad
-- Ewmh Screen
import XMonad.Hooks.EwmhDesktops
-- ManageHook
import XMonad.Hooks.ManageHelpers
-- Key Binding
import XMonad.Actions.CycleWS
import XMonad.Actions.Navigation2D
import XMonad.Util.EZConfig(additionalKeysP)
import qualified XMonad.StackSet as W
import qualified Data.Map as M
-- Layout
import XMonad.Layout.EqualSpacing
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
-- Xmonad + PolyBAR
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import qualified XMonad.DBus as D
import qualified DBus.Client as DC
import XMonad.Util.Loggers
import XMonad.Util.WorkspaceCompare
import Data.List
import Data.List.Split

myBorderWidth        = 4
myClickJustFocuses :: Bool
myClickJustFocuses   = True
myTerminal           = "alacritty" 
myWorkspaces       :: [String]
myWorkspaces         = ["I","II","III", "IV","V","VI","VII","VIII"]
-- myWorkspaces         = ["1","2","3","4","5","6","7","8"]

-- Colours
myFocusedBorderColor = "#F5C035"
myNormalBorderColor  = "#reformat"
gray      = "#7F7F7F"
yellow    = "#F5C035"
yellow2   = "#755B1A"

myLayoutHook = avoidStruts $ equalSpacing 10 4 0 20 (
    tiled ||| Mirror tiled ||| Full
    )
  where
    tiled = Tall nmaster delta ratio
    nmaster = 1
    ratio = 1/2
    delta = 3/100

myManageHook :: ManageHook
myManageHook = composeAll . concat $
    [ [ className =? b --> doShift "I"                     | b <- myBrowsers   ]
    , [ className =? c --> doShift "II"                    | c <- myComs       ]
    , [ className =? "Alacritty" --> doShift "III"   ]
    , [ className =? "Deadbeef" --> doShift "IV"   ]
    , [ className =? d --> doShift "V" | d <- myGames  ]
    , [ className =? e --> doShift "VI" | e <- myGameLaunchers  ]
    , [ className =? "Bitwarden" --> doShift "VIII"   ]
    , [ isFullscreen --> doF W.focusDown <+> doFullFloat <+> hasBorder False ]
    , [ isDialog --> doFloat ]
    , [ className =? g --> doCenterFloat | g <- myFloats                    ]
    ]
  where
      myBrowsers      = [ "qutebrowser", "Falkon", "Vivaldi-stable", "firefox" ]
      myGames         = [ "dota2", "clonehero", "Dwarf_Fortress", "Blender" ]
      myComs          = [ "TelegramDesktop", "Element", "discord" ]
      myFloats        = [ "ranger" ]
      myGameLaunchers = [ "Steam", "heroic" ]

rmdups :: Eq a => [a] -> [a]
rmdups [] = []
rmdups (x:xs)   | x `elem` xs   = rmdups xs
                | otherwise     = x : rmdups xs

removeItem _ []                 = []
removeItem x (y:ys) | x == y    = removeItem x ys
                    | otherwise = y : removeItem x ys

boolToString :: Bool -> [String]
boolToString True = ["TRUE"]
boolToString False = ["FALSE"]

finalDestination :: String -> [String] -> [String]
finalDestination cs (w:ws) = foldr (\x xs -> if (x /= cs) then x:xs else reformat cs:xs) [] (w:ws)

reformat :: String -> String
reformat x = wrap ("%{F" ++ yellow ++ "}") "%{F-}" ((split (dropBlanks $ dropDelims $ oneOf "$}") x) !! 1)

myLogHook :: DC.Client -> ScreenId -> String -> PP
myLogHook dbus i s = def {
    ppCurrent = formatUnfocused
    , ppVisible = formatUnfocused
    , ppHidden  = formatUnfocused
    , ppHiddenNoWindows = wrap ("%{F" ++ gray ++ "}") "%{F-}"
    , ppOutput  = D.sendToPath dbus s 
    , ppSep     = "  "
    , ppOrder   = \(ws : _ : _ : wins : cs) -> finalDestination (head cs) (words ws) <> [wins]
    , ppExtras  = [titlesOnScreen, currentOnScreen]
}
    where
        titlesOnScreen  = logDefault (shortenL 70 $ logTitlesOnScreen i formatFocused formatUnfocused) (logConst "Hey, you, you're finally awake.")
        currentOnScreen = wrapL ("%{F" ++ yellow2 ++ "}") "%{F-}" $ logCurrentOnScreen i
        formatFocused   = wrap ("%{F" ++ yellow ++ "}") "%{F-}"
        formatUnfocused = wrap ("%{F" ++ yellow2 ++ "}") "%{F-}" 

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch a terminal
    [ ((modm,                xK_Return), spawn $ XMonad.terminal conf)

    -- launch rofi drun
    , ((modm,                xK_p     ), spawn "rofi -show drun")

    -- launch rofi -show 
    , ((modm .|. controlMask,xK_p     ), spawn "rofi -show")

    -- launch clipmenu
    , ((modm,                xK_v     ), spawn "clipmenu")

    -- close focused window
    , ((modm,                xK_q     ), kill)

    -- next layout
    , ((modm,                xK_space ), sendMessage NextLayout)

    -- move focus to the next window
    , ((modm,                xK_Tab   ), windows W.focusDown)

    -- push window back into tiling
    , ((modm,                xK_t     ), withFocused $ windows . W.sink)

    -- increment the number of windows in the master area
    , ((modm,                xK_comma ), sendMessage (IncMasterN 1))

    -- deincrement the number of windows in the master area
    , ((modm,                xK_period), sendMessage (IncMasterN (-1)))

    -- toggle the status bar gap
    , ((modm,                xK_b     ), sendMessage ToggleStruts)

    -- restart xmonad
    , ((modm .|. shiftMask,  xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- logout 
    , ((modm .|. controlMask,xK_q     ), spawn "loginctl terminate-user hibiscus-tea")

    -- swap adjacent windows             | no arrowkeys
    , ((modm,                xK_l     ), windowGo   R True)
    , ((modm,                xK_h     ), windowGo   L True)
    , ((modm,                xK_k     ), windowGo   U True)
    , ((modm,                xK_j     ), windowGo   D True)

    -- directional navigation of windows | no arrowkeys   
    , ((modm .|. shiftMask,  xK_l     ), windowSwap R True)
    , ((modm .|. shiftMask,  xK_h     ), windowSwap L True)
    , ((modm .|. shiftMask,  xK_k     ), windowSwap U True)
    , ((modm .|. shiftMask,  xK_j     ), windowSwap D True)

    -- swap adjacent windows
    , ((modm,                xK_Right ), windowGo   R True)
    , ((modm,                xK_Left  ), windowGo   L True)
    , ((modm,                xK_Up    ), windowGo   U True)
    , ((modm,                xK_Down  ), windowGo   D True)

    -- directional navigation of windows
    , ((modm .|. shiftMask,  xK_Right ), windowSwap R True)
    , ((modm .|. shiftMask,  xK_Left  ), windowSwap L True)
    , ((modm .|. shiftMask,  xK_Up    ), windowSwap U True)
    , ((modm .|. shiftMask,  xK_Down  ), windowSwap D True)
    ]

    ++
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1, xK_2, xK_3, xK_4, xK_F1, xK_F2, xK_F3, xK_F4]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

    ++
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_a, xK_s, xK_d] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $ [
    -- mod-button1, Set rhe window to floating mode and resize by dragging
      ((modm, button3), (\w -> XMonad.focus w >> mouseResizeWindow w
        >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> XMonad.focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and move by dragging
    , ((modm, button1), \w -> 
        focus w >>
            mouseMoveWindow w >>
                windows W.shiftMaster)
    , ((modm .|. shiftMask, button3), (\w -> XMonad.focus w >> mouseMoveWindow w
        >> windows W.shiftMaster))
    ] 

main :: IO ()
main = do
     -- Connect to DBus
     dbus <- D.connect
     -- Request Access (needed when sending messages)
     D.requestAccess dbus
     -- Start XMonad
     xmonad . ewmhFullscreen . ewmh $ myConfig { logHook = dynamicLogWithPP (myLogHook dbus 0 "DVI" ) >> dynamicLogWithPP (myLogHook dbus 1 "HDMI") } 

myConfig = def {
  terminal = myTerminal
, clickJustFocuses   = myClickJustFocuses
, modMask            = mod4Mask
, workspaces         = myWorkspaces
, keys               = myKeys
-- Hooks
, layoutHook         = smartBorders $ myLayoutHook
, manageHook         = manageDocks <+> myManageHook 
, borderWidth        = myBorderWidth
, normalBorderColor  = myNormalBorderColor
, focusedBorderColor = myFocusedBorderColor
}
