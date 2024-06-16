#!/usr/bin/env python3

import subprocess

brightness = subprocess.run(
    ["brightnessctl", "get", "-P"], capture_output=True
).stdout.decode("utf-8")

icons = [" ", " ", " ", " ", " ", " ", " ", " ", " "]
brightness = int(brightness)
index = int(brightness * 9 / 100) - 1
icon = icons[index]
print(icon)
