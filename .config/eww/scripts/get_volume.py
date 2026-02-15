#!/usr/bin/env python3

import subprocess

volume_status = (
    subprocess.run(
        "amixer get Master | grep -oP '(?<=\[).*?(?=%\])' | tail -n 1",
        shell=True,
        capture_output=True,
    )
    .stdout.decode("utf-8")
    .strip()
)

print(volume_status)
