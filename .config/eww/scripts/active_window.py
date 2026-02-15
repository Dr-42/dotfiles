#!/usr/bin/env python3

import subprocess
import json

hypr_info = subprocess.run(
    ["hyprctl", "clients", "-j"], capture_output=True
).stdout.decode("utf-8")

hypr_info_json = json.loads(hypr_info)

for client in hypr_info_json:
    if client["focusHistoryID"] == 0:
        print(client["title"])
        break
