#!/usr/bin/env python3

import os
import sys

arg = sys.argv[1]

if arg == "sleep":
    os.system("systemctl suspend")
elif arg == "hibernate":
    os.system("systemctl hibernate")
elif arg == "shutdown":
    os.system("shutdown now")
elif arg == "restart":
    os.system("reboot")
elif arg == "logout":
    os.system("hyprctl dispatch exit")
else:
    sys.exit(1)
