------------------------------------------------------------------------
---------------------------- XMOBAR CONFIG -----------------------------
------------------------------------------------------------------------
-- documentation : http://projects.haskell.org/xmobar/#system-monitor-plugins.
------------------------------------------------------------------------


Config { 

   template = "%UnsafeStdinReader% }%date1% %date2% %LFPB%   { %dynnetwork% %memory% %multicpu% %coretemp%%bright% <action=pavucontrol>%default:Master%</action>%kbd% %battery%|--"
   --, template = "%date3% %LFPB% %date4% | %UnsafeStdinReader% }{ %dynnetwork% %memory% %multicpu% %coretemp% %bright% <action=pavucontrol>%default:Master%</action>%kbd% %battery%"

------------------------------------------------------------------------

   ,font = "xft:Sauce Code Pro Nerd Font:size=9.5:bold, xft:NotoColorEmoji:size=9, xft:Inconsolata:size=9"
   -- font = "xft:Bitstream Vera Sans Mono:size=10:bold, xft:FreeSerif:style=Regular"
   --, additionalFonts = [ "xft:FontAwesome-Regular:pixelsize:8"]
   --, additionalFonts = [ "xft:FreeSerif:style=Regular"]
   --, additionalFonts = [ "xft:FontAwesome 6 Free Solid:pixelsize=14", "xft:FontAwesome:pixelsize=10:bold", "xft:FontAwesome 6 Free Solid:pixelsize=16", "xft:Hack Nerd Font Mono:pixelsize=21", "xft:Hack Nerd Font Mono:pixelsize=25" ]
   --, additionalFonts = [ "xft:noto-fonts-emoji:size=10:antialias=tr" , "FontAwesome:pixelsize=10" , "xft:Inconsolata:hinting=true:size=12", "xft:Noto Sans Mono", "xft:IPAGothic", "xft:Symbola", "xft:FontAwesome:pixelsize=12", "-*-unifont-*-*-*-*-*-*-*-*-*-*-*-*", "M+1c:pixelsize=10"]  
   -- other languagas : FreeSerif, Droid Sans Mono, DejaVu Sans Mono, Courier New, inconsolata

------------------------------------------------------------------------

   , bgColor =      "#000000"
   , fgColor =      "#646464"
   , position =     Top
   , border =       BottomB
   , borderColor =  "black" 
   --, bgColor =      "black"
   -- white border color #646464
   , sepChar =  "%"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment
   , lowerOnStart =     True    -- send to bottom of window stack on start
   , hideOnStart =      False   -- start with window unmapped (hidden)
   , allDesktops =      True    -- show on all desktops
   , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
   , pickBroadest =     False   -- choose widest display (multi-monitor)
   , persistent =       True    -- enable/disable hiding (True = disabled)
--   , position = Static { xpos = 0, ypos = 0, width = 1346, height = 20 }
------------------------------------------------------------------------

   , commands = [
        -- Run Weather "LFPB" [ "--template", "<skyCondition> | <fc=#4682B4><tempC></fc>°C | <fc=#4682B4><rh></fc>%"] 36000,
         Run Weather "LFPB" [ "--template", "<tempC>°"
                            , "--Low"     , "12"        -- units: °C
                            , "--High"     , "30"       
                            , "--low"     , "white"
						              --, "--normal"  , "darkgreen"
                            , "--high"    , "white"
                            ] 50

--         ,Run Weather "LFPB" [ "--template", "<rh>懲 <skyCondition>"
--                            , "--template", "<tempC>°"
--                            , "--Low"     , "12"        -- units: °C
--                            , "--High"     , "30"       
--                            , "--low"     , "white"
--						              --, "--normal"  , "darkgreen"
--                            , "--high"    , "white"
--                            ] "LFPB2" 150

        -- network activity monitor (dynamic interface resolution)
         ,Run DynNetwork     [ "--template" , "<tx> <rx>"
                             , "--Low"      , "1000"       -- units: B/s
                             , "--High"     , "10000"       -- units: B/s
--                             , "--low"      , "darkgreen"
                             , "--normal"   , "darkgreen"
                             , "--high"     , "darkred"
                             ] 10

        , Run MultiCpu       [ "--template" , "<total0>-<total1>"
                             , "--Low"      , "1"         -- units: %
                             , "--High"     , "25"         -- units: %
                             --, "--low"      , "darkgreen"
                             , "--normal"   , "darkgreen"
                             --, "--normal"   , "darkorange"
                             , "--high"     , "darkred"
                             ] 10

        , Run CoreTemp       [ "--template" , "<core0>-<core1>°"
                             , "--Low"      , "55"        -- units: °C
                             --, "--Low"      , "60"        -- units: °C
                             , "--High"     , "80"        -- units: °C
                             --, "--low"      , "darkgreen"
                             , "--normal"   , "darkorange"
                             , "--high"     , "darkred"
                             ] 10
                          
        , Run Memory         [ "--template" ,"<usedratio>"
                             , "--Low"      , "10"        -- units: %
                             , "--normal"   , "20"        -- units: %
                             , "--High"     , "50"        -- units: %
--                             , "--low"      , "darkgreen"
                             , "--normal"   , "darkorange"
                             , "--high"     , "darkred"
                             ] 10

        , Run Battery        [ "--template" , "<acstatus>"
                             , "--Low"      , "20"        -- units: %
                             , "--High"     , "70"        -- units: %
	                      		 -- , "--Critical"  , "10"        -- units: %
                             , "--low"      , "red"
                             -- , "--Critical"  , "darkred"
                             --, "--normal"   , ""
                             --, "--high"     , "darkgreen"
			                      , "-a", "notify-send -u critical 'Battery running out!!!!!!'"
                             , "--" -- battery specific options
                              -- discharging status
                             , "-o"	, "<left>  <timeleft>"
                              -- AC "on" status
                             , "-O"	, "<left><fc=lightblue>  </fc><timeleft>"        
					                   -- , "-O"   , "lightblue"            
                             -- charged status
                             , "-i"	, "<fc=#006000><left>  <timeleft> </fc>"
                             ] 10

        --   (%F = d-m-y date, %a = day of week, %T = h:m:s time)
        --, Run Date           "<fc=#ffffff> %T</fc> %a %F" "date0" 10
        , Run Date           "%F<fc=#ffffff> %T</fc>" "date1" 01
        , Run Date           "%a" "date2" 10 
        --, Run Date           "<fc=#ffffff>%T</fc>" "date3" 10
        --, Run Date           "%a %F" "date4" 50
      	--, Run Date "%d %b %T" "date5" 10

        , Run Kbd            [ ("us(intl)" , "<fc=#ABABAB>INTL</fc>")
                             , ("fr"         , "<fc=#ABABAB>FR</fc>")
                             , ("ara"         , "<fc=#ABABAB>AR</fc>")
                             , ("us"         , "<fc=#ABABAB>US</fc>")
                             ] 
      	-- , Run Swap [] 10

      	, Run Brightness     [ "-t", "<percent>盛", "--", "-D", "intel_backlight" ] 10
	
        , Run Volume "default" "Master"
  	                       	 [ "-t", "<status>", "--"
                             , "--on", "<volume>墳 "
                             , "--onc", "#646464"
                             , "--off", "<fc=darkgreen>MUTE婢 </fc>"
                             , "--offc", "#dc322f"
                             ] 5
	
        , Run UnsafeStdinReader
	
    	  --, Run Com "echo" ["<fn=1></fn>"] "spotify" 3600	
    	  --, Run Mpris2 "spotify" ["-t", "<artist> <fn=1> </fn> <title>"] 10
	      --, Run Mpris2 "spotify" ["-t", "<title>"] 50
        -- <fc=#ABABAB>%mpris2%</fc> 

        ]
   }

