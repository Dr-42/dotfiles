#!/usr/bin/env python3

import os
from Pylette import extract_colors


def get_lightness(rgb):
    return 0.2126 * rgb[0] + 0.7152 * rgb[1] + 0.0722 * rgb[2]


def luminance(r, g, b):
    GAMMA = 2.4  # Ensure this is set correctly as per your requirement
    RED = 0.2126
    GREEN = 0.7152
    BLUE = 0.0722

    def transform(v):
        v /= 255
        return v / 12.92 if v <= 0.03928 else ((v + 0.055) / 1.055) ** GAMMA

    a = list(map(transform, [r, g, b]))
    return a[0] * RED + a[1] * GREEN + a[2] * BLUE


def make_readable(fg, bg):
    # Make the luminance of the text color readable on the background color
    # lumnance ratio is to be greater than 4.5
    # https://www.w3.org/TR/WCAG20-TECHS/G18.html

    fg_lum = luminance(fg[0], fg[1], fg[2])
    bg_lum = luminance(bg[0], bg[1], bg[2])

    if fg_lum > bg_lum:
        ratio = (fg_lum + 0.05) / (bg_lum + 0.05)
    else:
        ratio = (bg_lum + 0.05) / (fg_lum + 0.05)

    if ratio < 4.5:
        if fg_lum > bg_lum:
            # Make the text color darker
            fg = (fg[0] * 0.8, fg[1] * 0.8, fg[2] * 0.8)
        else:
            # Make the text color lighter
            fg = (
                fg[0] + (255 - fg[0]) * 0.2,
                fg[1] + (255 - fg[1]) * 0.2,
                fg[2] + (255 - fg[2]) * 0.2,
            )

    return (fg, bg)


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

(textrgb, textrgb_inv) = make_readable(textrgb, textrgb_inv)


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
    text-shadow:
        0.07em 0 black,
        0 0.07em black,
        -0.07em 0 black,
        0 -0.07em black;
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
}}

.end-default-notification-box {{
  background-color: {10};
  padding: 12px;
  padding-left: 8px;
  margin: 12px;
  border-radius: 10px;
}}

.notification-text {{
  color: {11};
  font-family: 'JetBrainsMono Nerd Font';
}}

.notification-title {{
  font-weight: bold;
  font-size: 1em;
}}

.notification-content {{
  font-size: .8em;
}}

.end-history-frame {{
    background-color: {10};
    padding: 12px;
    padding-left: 8px;
    border-radius: 10px;
}}

.end-history-box {{
    background-color: {10};
    padding: 12px;
    padding-left: 8px;
}}

.content-box {{
  margin-left: 12px;
}}

.battery-icon {{
  color: rgb(255, 0, 0);
  font-size: 2.1em;
  margin-right: 48px;
  margin-left: 24px;
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
