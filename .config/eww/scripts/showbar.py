#!/usr/bin/env python3

import subprocess
import json

hyprout = (
    subprocess.run("hyprctl activeworkspace -j", shell=True, capture_output=True)
    .stdout.decode("utf-8")
    .strip()
)
curpos = (
    subprocess.run("hyprctl cursorpos -j", shell=True, capture_output=True)
    .stdout.decode("utf-8")
    .strip()
)

hyprout = json.loads(hyprout)
curpos = json.loads(curpos)

if curpos["y"] < 30:
    print("true")
elif hyprout["windows"] == 0:
    print("true")
else:
    print("false")
