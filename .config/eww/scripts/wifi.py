#!/usr/bin/python

import subprocess

icons = ["󰌗 ", "󰤨 ", "󰤭 "]

ifconfig_data = subprocess.check_output(["ifconfig"]).decode("utf-8").split("\n")

group_data = []
group_count = 0
for i in range(len(ifconfig_data)):
    if ifconfig_data[i] != "":
        if group_count >= len(group_data):
            group_data.append([])
        group_data[group_count].append(ifconfig_data[i])
    else:
        group_count += 1


def get_out():
    for i in range(len(group_data)):
        for j in range(len(group_data[i])):
            if "enp" in group_data[i][j]:
                for k in range(len(group_data[i])):
                    if "inet" in group_data[i][k]:
                        return icons[0]

            if "wlp" in group_data[i][j]:
                for k in range(len(group_data[i])):
                    if "inet" in group_data[i][k]:
                        return icons[1]

    return icons[2]


out = get_out()

print(out)
