#!/usr/bin/env python3

# get arguments from command line
import sys
import os

args = sys.argv

# check if the number of arguments is correct
if len(args) != 2:
    print("Usage: set_volume.py <volume>")
    sys.exit(1)

if args[1] == "up":
    os.system("amixer sset Master 5%+")
elif args[1] == "down":
    os.system("amixer sset Master 5%-")
