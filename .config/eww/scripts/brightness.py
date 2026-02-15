#!/usr/bin/env python3

import subprocess
from math import ceil

brightness = subprocess.run(
    ["brightnessctl", "get", "-P"], capture_output=True
).stdout.decode("utf-8")

icons = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
brightness = int(brightness)
index = ceil(brightness * (len(icons) - 1) / 100)
if index < 0:
    index = 0
icon = icons[index]
print(icon)
