#!/usr/bin/env python3

import os
from Pylette import extract_colors


def get_lightness(rgb):
    return 0.2126 * rgb[0] + 0.7152 * rgb[1] + 0.0722 * rgb[2]


# Get the wallpaper path from .cache/.wallpaper
wallpaper_path = ""
home = os.path.expanduser("~")
try:
    with open(home + "/.cache/.wallpaper", "r") as f:
        wallpaper_path = f.read().strip()
except FileNotFoundError:
    wallpaper_path = home + "/dotfiles/Wallpapers/GLADOS.jpg"

# Get the wallpaper color

colors = extract_colors(
    image=wallpaper_path,
    palette_size=6,
    resize=True,
    mode="MC",
    sort_mode="luminance",
)
colors = [color.rgb for color in colors]

dialcolor = "rgb({0}, {1}, {2})".format(
    255 - colors[0][0], 255 - colors[0][1], 255 - colors[0][2]
)
hourcolor = "rgb({0}, {1}, {2})".format(colors[1][0], colors[1][1], colors[1][2])
minutecolor = "rgb({0}, {1}, {2})".format(colors[2][0], colors[2][1], colors[2][2])
secondcolor = "rgb({0}, {1}, {2})".format(colors[3][0], colors[3][1], colors[3][2])
markerfilledcolor = "rgba({0}, {1}, {2}, 0.2)".format(
    colors[4][0], colors[4][1], colors[4][2]
)
markeremptycolor = "rgba({0}, {1}, {2}, 0.1)".format(
    colors[4][0], colors[4][1], colors[4][2]
)

textrgb = colors[5]
textrgb_inv = (255 - textrgb[0], 255 - textrgb[1], 255 - textrgb[2])


if get_lightness(textrgb) > get_lightness(textrgb_inv):
    tmp = textrgb
    textrgb = textrgb_inv
    textrgb_inv = tmp


textcolor = "rgb({0}, {1}, {2})".format(textrgb[0], textrgb[1], textrgb[2])
textbg = "rgba({0}, {1}, {2}, 0.8)".format(
    textrgb_inv[0], textrgb_inv[1], textrgb_inv[2]
)

bar_bg = "rgba({0}, {1}, {2}, 0.7)".format(colors[0][0], colors[0][1], colors[0][2])

bar_fg = "rgba({0}, {1}, {2}, 0.9)".format(
    255 - colors[0][0], 255 - colors[0][1], 255 - colors[0][2]
)

bar_fg_hover = "rgba({0}, {1}, {2}, 0.7)".format(
    255 - colors[1][0], 255 - colors[1][1], 255 - colors[1][2]
)

bar_bg_hover = "rgba({0}, {1}, {2}, 0.7)".format(
    colors[1][0], colors[1][1], colors[1][2]
)

bar_border = "rgba({0}, {1}, {2}, 0.9)".format(
    255 - colors[1][0], 255 - colors[1][1], 255 - colors[1][2]
)

bar_shadow = "rgba({0}, {1}, {2}, 0.9)".format(
    255 - colors[2][0], 255 - colors[2][1], 255 - colors[2][2]
)

css = """.bar {{
    background-color: {10};
}}

.workspaces {{
    background-color: {10};
    border-radius: 10px;
    color: {11};
    border: 1px solid {12};
    padding: 6px 20px 4px 20px;
    font-size: 16px;
    box-shadow: 2px 2px 2px {13};
}}

.time_battery {{
    background: {10};
    border-radius: 10px;
    color: {11};
    font-size: 16px;
    padding: 5px 15px 5px 14px; 
    border: 1px solid {12};
    box-shadow: 2px 2px 2px {13};
    text-shadow: none;
}}

.clockmarkerfilled {{
    color: {0};
    background-color: rgba(255, 0, 0, 0);
}}

.clockmarkerempty {{
    color: {1};
    background-color: rgba(255, 0, 0, 0);
}}

.hour {{
    background-color: {2};
    color: {9};
}}

.minute {{
    background-color: {3};
    color: {9};
}}

.second {{
    background-color: {4};
    color: {9};
}}

.clocktext {{
    margin: 0;
    padding: 0;
    font-size: 20px;
    color: {5};
    background-color: {6};
    border-radius: 150px 150px 0 0;
}}

.clockdate {{
    margin: 0;
    padding: 0;
    font-size: 13px;
    color: {7};
    background-color: {8};
    border-radius: 0 0 150px 150px;
}}

.clockmarker {{
    color: #ff0000;
}}

.powertray {{
    background-color: {10};
    border-radius: 10px;
    color: {11};
    border: 1px solid {12};
    padding: 6px 20px 4px 20px;
    font-size: 16px;
    box-shadow: 2px 2px 2px {13};
    min-width: 300px;
    min-height: 80px;
}}

.powertray:hover {{
    background-color: {10};
    border-radius: 10px;
    color: {11};
    border: 1px solid {12};
    padding: 6px 20px 4px 20px;
    font-size: 16px;
    box-shadow: 2px 2px 2px {13};
    min-width: 300px;
    min-height: 80px;
}}

.powertray-button {{
    background-color: {10};
    border-radius: 10px;
    color: {11};
    border: 1px solid {12};
    padding: 8px 20px 4px 20px;
    font-size: 22px;
    box-shadow: 2px 2px 2px {13};
    min-width: 40px;
    min-height: 60px;
}}

.powertray-button:hover {{
    background-color: {11};
    border-radius: 10px;
    color: {10};
    border: 1px solid {12};
    padding: 8px 20px 4px 20px;
    font-size: 22px;
    box-shadow: 2px 2px 2px {13};
    min-width: 40px;
    min-height: 60px;
}}"""

css = css.format(
    markerfilledcolor,
    markeremptycolor,
    hourcolor,
    minutecolor,
    secondcolor,
    textcolor,
    textbg,
    textcolor,
    textbg,
    dialcolor,
    bar_bg,
    bar_fg,
    bar_border,
    bar_shadow,
)

print(css)