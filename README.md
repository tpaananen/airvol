# Description

Hammerspoon script to set AirPods intial volume to desired level instead of default level 50.0 that macos / macbooks set.

## Issue with Macbooks

Macbook Air / Pro sets the initial volume level 50.0 for AirPods Pro 2 and 3 / Max (that's what I have, maybe also with other AirPods).
This could potentially lead to hearing damage especially with young kids.

### How to reproduce the issue?

1. Turn off Macbook bluetooth device
2. Turn on Macbook bluetooth device
3. Connect AirPods to the Macbook (either manually or let them connect automatically depending on your settings)
4. See that volume is set to 50, slider position is in the middle
   - Sometimes the volume is set properly to other than 50, but most of the times for me it is set to 50.0.

See also example [console.log](https://github.com/tpaananen/airvol/blob/main/console.log) how Macbook behaves when AirPods connect as default device.

### Workaround

Since Apple is completely incompetent to fix this years old major issue (I have personally reported this multiple times), we are forced to work around the issue by using 3rd party tools.
If you are seeing this issue with your devices, please report the issue via [Apple's feedback channels](https://www.apple.com/feedback/). If more people report, maybe they begin to respect people's hearing and physical well-being.

[init.lua](https://github.com/tpaananen/airvol/blob/main/init.lua) tries to force the initial volume level to your desired level using retries if it detects that the call to set the volume is not respected by macos / Macbook.

## Installation

Install Hammerspoon for macos, see instructions in their repository: <https://github.com/Hammerspoon/hammerspoon>.
If you want Hammerspoon to start when you login, you need to set that also manually.

Save [init.lua](https://github.com/tpaananen/airvol/blob/main/init.lua) file to `~/.hammerspoon/init.lua`

Start Hammerspoon and load the script.

You can monitor the behavior of the script by looking at the console output of Hammerspoon. Open console from Hammerspoon menu icon -> `Console...`

The script will "notify" you by putting out a soft alert that the volume has been set when it's set and the same for total failure.

## Credits

Originally found from this [Reddit post](https://www.reddit.com/r/MacOS/comments/16wkyvu/comment/n6tli2g) and modified to contain the retry logic etc. when I noticed that the initial set may not succeed.
