#!/usr/bin/env python3

import subprocess

icons = ["󰕾 ", "󰖁 "]

# Get current volume status
volume_status = (
    subprocess.run(
        "amixer get Master | grep -oP '(?<=\[).*?(?=%\])' | tail -n 1",
        shell=True,
        capture_output=True,
    )
    .stdout.decode("utf-8")
    .strip()
)

vol = int(volume_status)

is_muted = subprocess.run(
    "amixer get Master | grep -oP '(?<=\[).*?(?=\])' | tail -1",
    shell=True,
    capture_output=True,
).stdout.decode("utf-8")

if "off" in is_muted:
    print(icons[1])
else:
    print(icons[0])
