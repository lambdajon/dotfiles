import XMonad.Hooks.StatusBar.PP (wrap)
import Xmobar
import XMonadConfig.GruvboxMaterial

config :: Config
config =
  defaultConfig
    { font = "xft:JetBrainsMono Nerd Font:size=10"
    , additionalFonts =
        [ "xft:JetBrainsMono Nerd Font:weight=bold:size=10"
        , "xft:Symbols Nerd Font Mono:size=14"
        ]
    , bgColor = background
    , fgColor = foreground
    , border = BottomB
    , borderColor = "#32302f"
    , borderWidth = 5
    , position = TopSize L 100 28
    , commands = myCommands
    , sepChar = "%"
    , alignSep = "}{"
    , template =
        myLogo
          ++ wrap " " " " (green "%uname%")
          ++ "%uptime%"
          ++ "%_XMONAD_LOG_1%"
          ++ "} %date% {"
          ++ "%disku%"
          ++ "%battery%"
    }
  where
    myLogo :: String
    myLogo = wrap " " " " "<fn=2>\xe712</fn>"

    myCommands :: [Runnable]
    myCommands =
      [ Run $ XPropertyLog "_XMONAD_LOG_1"
      , Run $
          Com
            "uname"
            ["-r", "-s"]
            ""
            (0 `seconds`)
      , Run $
          DateZone
            (grey2 "%A %B %d %Y " ++ yellow "%H:%M:%S")
            ""
            "Asia/Tashkent"
            "date"
            (1 `seconds`)
      , Run $
          DiskU
            [ ("/", inWrapper' (ppTitle "System" ++ ppDiskSpace))
            ]
            []
            (30 `minutes`)
      , Run $
          Uptime
            [ "--template"
            , inWrapper (ppTitle "Uptime" ++ red "<days>d <hours>h <minutes>m")
            ]
            (60 `seconds`)
      , Run $
          Battery
            [ "--template"
            , inWrapper (ppTitle "Battery" ++ "<acstatus>")
            , "--"
            , "-o"
            , green "<left>%" ++ grey2 " <timeleft>"
            , "-O"
            , yellow "<left>%" ++ grey2 " charging"
            , "-i"
            , aqua "full"
            ]
            (30 `seconds`)
      ]
      where
        ppDiskSpace :: String
        ppDiskSpace = orange "<used>" ++ grey0 "/" ++ aqua "<free>"

        seconds :: Int -> Int
        seconds = (* 10)

        minutes :: Int -> Int
        minutes = (60 *) . seconds

        ppTitle :: String -> String
        ppTitle = wrap "" ": " . grey2

        inWrapper :: String -> String
        inWrapper = wrap (grey0 " <fn=1>[</fn> ") (grey0 " <fn=1>]</fn> ")

        inWrapper' :: String -> String
        inWrapper' = wrap (grey0 "<fn=1>[</fn> ") (grey0 " <fn=1>]</fn> ")

main :: IO ()
main = configFromArgs config >>= xmobar
