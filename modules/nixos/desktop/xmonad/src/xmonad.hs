import System.Exit
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isDialog, isFullscreen, doFullFloat)
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import Graphics.X11.ExtraTypes.XF86

main :: IO ()
main = xmonad . docks . ewmhFullscreen . ewmh $ myConfig

myConfig = def
  { modMask            = mod4Mask
  , terminal           = "alacritty"
  , borderWidth        = 2
  , normalBorderColor  = "#32302f"
  , focusedBorderColor = "#a9b665"
  , workspaces         = ["1", "2", "3", "4", "5"]
  , layoutHook         = myLayouts
  , manageHook         = myManageHook
  , keys               = \c -> myKeys c `M.union` keys def c
  }

myLayouts = avoidStruts (ResizableTall 1 (3/100) (1/2) [] ||| noBorders Full)

myManageHook = composeAll
  [ isDialog     --> doFloat
  , isFullscreen --> doFullFloat
  ]

myKeys (XConfig { modMask = modm }) = M.fromList
  [ ((modm .|. shiftMask, xK_q),      io exitSuccess)
  , ((modm .|. shiftMask, xK_c),      kill)
  , ((modm,               xK_p),      spawn "rofi -show run")
  , ((modm .|. shiftMask, xK_Return), spawn "alacritty")
  , ((modm,               xK_j),      windows W.focusDown)
  , ((modm,               xK_k),      windows W.focusUp)
  , ((modm .|. shiftMask, xK_j),      windows W.swapDown)
  , ((modm .|. shiftMask, xK_k),      windows W.swapUp)
  , ((0, xF86XK_AudioLowerVolume),    spawn "amixer set Master 5%-")
  , ((0, xF86XK_AudioRaiseVolume),    spawn "amixer set Master 5%+")
  , ((0, xF86XK_AudioMute),           spawn "amixer set Master toggle")
  ]
