#!/usr/bin/env python3

# Print the path to a random image in $HOME/dotfiles/Wallpapers

import os
import random

wallpapers_dir = os.path.expanduser("~/dotfiles/Wallpapers")

wallpapers = os.listdir(wallpapers_dir)
wallpaper = random.choice(wallpapers)

complete_path = os.path.join(wallpapers_dir, wallpaper)

print(complete_path)

# save the wallpaper path in a file
with open(os.path.expanduser("~/.cache/.wallpaper"), "w") as f:
    f.write(complete_path)
    f.close()
