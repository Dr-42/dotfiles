#!/usr/bin/env python3

import subprocess
import json

hypr_ws = (
    subprocess.run("hyprctl activeworkspace -j", shell=True, capture_output=True)
    .stdout.decode("utf-8")
    .strip()
)
curpos = (
    subprocess.run("hyprctl cursorpos -j", shell=True, capture_output=True)
    .stdout.decode("utf-8")
    .strip()
)
hypr_wins = (
    subprocess.run("hyprctl clients -j", shell=True, capture_output=True)
    .stdout.decode("utf-8")
    .strip()
)

hypr_ws = json.loads(hypr_ws)
curpos = json.loads(curpos)
hypr_wins = json.loads(hypr_wins)


def get_window_res(active_ws, y_thresh):
    for window in hypr_wins:
        if window["workspace"]["id"] == active_ws:
            if window["at"][1] < y_thresh:
                return False

    return True


if curpos["y"] < 30:
    print("true")
elif hypr_ws["windows"] == 0:
    print("true")
elif get_window_res(hypr_ws["id"], 40):
    print("true")
else:
    print("false")
