#!/usr/bin/python

import subprocess
import json

icons = ["󰄰", "󰄯", "⌾︎"]

has_window = [False] * 9

hyprinfo = subprocess.run(
    "hyprctl workspaces -j", shell=True, capture_output=True
).stdout.decode("utf-8")
hyprinfo_json = json.loads(hyprinfo)

for entry in hyprinfo_json:
    if entry["id"]:
        has_window[entry["id"] - 1] = True

activeworkspace_info = subprocess.run(
    "hyprctl activeworkspace -j", shell=True, capture_output=True
).stdout.decode("utf-8")
activeworkspace_info_json = json.loads(activeworkspace_info)

activeworkspace = activeworkspace_info_json["id"]

window_icons = []

for i in range(9):
    if activeworkspace == i + 1:
        window_icons.append(icons[1])
    elif has_window[i]:
        window_icons.append(icons[2])
    else:
        window_icons.append(icons[0])


output = '(box :class "workspaces" :halign "start" :spacing 8'

for i in range(9):
    output += (
        '(button :onclick "hyprctl dispatch workspace '
        + str(i + 1)
        + '" "'
        + window_icons[i]
        + '")'
    )

output += ")"

print(output)
