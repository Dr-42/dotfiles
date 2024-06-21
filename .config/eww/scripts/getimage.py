#!/usr/bin/env python3

# Print the path to a random image in $HOME/dotfiles/Wallpapers

import os
import random
import subprocess

wallpapers_dir = os.path.expanduser("~/dotfiles/Wallpapers")

wallpapers = os.listdir(wallpapers_dir)
wallpaper = random.choice(wallpapers)

complete_path = os.path.join(wallpapers_dir, wallpaper)

# save the wallpaper path in a file
with open(os.path.expanduser("~/.cache/.wallpaper"), "w") as f:
    f.write(complete_path)
    f.close()

# extract colors from the wallpaper
css = subprocess.run(["scripts/getcss.py"], capture_output=True).stdout.decode("utf-8")
# append " before and after the css
# css = f'"{css}"'

arg = f"getcss={css}"

home = os.path.expanduser("~")
eww_binary = os.path.join(home, ".local/bin/eww")
subprocess.run([eww_binary, "update", arg])

print(complete_path)
