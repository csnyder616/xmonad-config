import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Actions.Volume
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import Graphics.X11.ExtraTypes.XF86 (xF86XK_AudioMute,
                                     xF86XK_AudioRaiseVolume,
                                     xF86XK_AudioLowerVolume)

xF86XK_AudioMicMute :: KeySym
xF86XK_AudioMicMute = 0x1008FFb2

main = do
	xmproc <- spawnPipe "/home/csnyder/.xmonad/scripts/launch-xmobar /home/csnyder/.xmonad/xmobarrc"
	xmonad $ defaultConfig
		{ manageHook = manageDocks <+> manageHook defaultConfig
        	, layoutHook = avoidStruts  $  layoutHook defaultConfig
		, logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                	, ppTitle = xmobarColor "green" "" . shorten 50
                	}
                , modMask = mod4Mask     -- Rebind Mod to the Windows key
        	} `additionalKeys`
                   [
                     ((0, xF86XK_AudioLowerVolume), lowerVolume 4 >> return()),
                     ((0, xF86XK_AudioRaiseVolume), raiseVolume 4 >> return()),
                     ((0, xF86XK_AudioMute), toggleMute >> return()),
                     ((0, xF86XK_AudioMicMute), spawn "amixer -q set Capture toggle") 
                   ]
