#!/usr/bin/env python3

import sys
import os

args = sys.argv

# check if the number of arguments is correct
if len(args) != 2:
    print("Usage: set_volume.py <volume>")
    sys.exit(1)

if args[1] == "up":
    os.system("brightnessctl set +5%")
elif args[1] == "down":
    os.system("brightnessctl set 5%-")
