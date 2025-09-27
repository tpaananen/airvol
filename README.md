# Description

Hammerspoon script to set AirPods intial volume to desired level instead of default level 50.0 that macos / macbooks set.
This tries to work around the issue with MacBook Air / Pro where the system initially sets the volume to 50 which can be dangerous to hearing.  

## Instructions

Install Hammerspoon for macos, see instructions in their repository: <https://github.com/Hammerspoon/hammerspoon>

Save [init.lua](https://github.com/tpaananen/airvol/blob/main/init.lua) file to `~/.hammerspoon/init.lua`

Start Hammerspoon and load the script.

The script (re)tries to set the desired level if macbook / macos races with the initial set with their 50 % level.

Originally found and modified from this [Reddit post](https://www.reddit.com/r/MacOS/comments/16wkyvu/comment/n6tli2g).
