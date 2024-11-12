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
        tmp = fg
        fg = bg
        bg = tmp

    ratio = (bg_lum + 0.05) / (fg_lum + 0.05)

    if ratio < 4.5:
        # Decrease the luminance of the fg color
        # to make it readable on the bg color
        fg_lum_new = (bg_lum + 0.05) / 4.5 - 0.05
        fg = (
            int(fg[0] * fg_lum_new / fg_lum),
            int(fg[1] * fg_lum_new / fg_lum),
            int(fg[2] * fg_lum_new / fg_lum),
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

bar_main_bg = "rgba({0}, {1}, {2}, 0.7)".format(
    colors[3][0], colors[3][1], colors[3][2]
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

css = f""".bar {{
    background-color: {bar_main_bg};
}}

.workspaces {{
    background-color: {bar_bg};
    border-radius: 10px;
    color: {bar_fg};
    border: 1px solid {bar_border};
    padding: 6px 20px 4px 20px;
    font-size: 16px;
    box-shadow: 2px 2px 2px {bar_shadow};
}}

.time_battery {{
    background: {bar_bg};
    border-radius: 10px;
    color: {bar_fg};
    font-size: 16px;
    padding: 5px 15px 5px 14px; 
    border: 1px solid {bar_border};
    box-shadow: 2px 2px 2px {bar_shadow};
    text-shadow:
        0.07em 0 black,
        0 0.07em black,
        -0.07em 0 black,
        0 -0.07em black;
}}

.clockmarkerfilled {{
    color: {markerfilledcolor};
    background-color: rgba(255, 0, 0, 0);
}}

.clockmarkerempty {{
    color: {markeremptycolor};
    background-color: rgba(255, 0, 0, 0);
}}

.hour {{
    background-color: {hourcolor};
    color: {dialcolor};
}}

.minute {{
    background-color: {minutecolor};
    color: {dialcolor};
}}

.second {{
    background-color: {secondcolor};
    color: {dialcolor};
}}

.clocktext {{
    margin: 0;
    padding: 0;
    font-size: 20px;
    color: {textcolor};
    background-color: {textbg};
    border-radius: 150px 150px 0 0;
}}

.clockdate {{
    margin: 0;
    padding: 0;
    font-size: 13px;
    color: {textcolor};
    background-color: {textbg};
    border-radius: 0 0 150px 150px;
}}

.clockmarker {{
    color: #ff0000;
}}

.powertray {{
    background-color: {bar_bg};
    border-radius: 10px;
    color: {bar_fg};
    border: 1px solid {bar_border};
    padding: 6px 20px 4px 20px;
    font-size: 16px;
    box-shadow: 2px 2px 2px {bar_shadow};
    min-width: 300px;
    min-height: 80px;
}}

.powertray:hover {{
    background-color: {bar_bg};
    border-radius: 10px;
    color: {bar_fg};
    border: 1px solid {bar_border};
    padding: 6px 20px 4px 20px;
    font-size: 16px;
    box-shadow: 2px 2px 2px {bar_shadow};
    min-width: 300px;
    min-height: 80px;
}}

.powertray-button {{
    background-color: {bar_bg};
    border-radius: 10px;
    color: {bar_fg};
    border: 1px solid {bar_border};
    padding: 8px 20px 4px 20px;
    font-size: 22px;
    box-shadow: 2px 2px 2px {bar_shadow};
    min-width: 40px;
    min-height: 60px;
}}

.powertray-button:hover {{
    background-color: {bar_fg};
    border-radius: 10px;
    color: {bar_bg};
    border: 1px solid {bar_border};
    padding: 8px 20px 4px 20px;
    font-size: 22px;
    box-shadow: 2px 2px 2px {bar_shadow};
    min-width: 40px;
    min-height: 60px;
}}

.end-default-notification-box-low {{
    background-color: {bar_bg};
    padding: 12px;
    padding-left: 8px;
    margin: 12px;
    border-radius: 10px;
    border: 1px dashed blue;
}}

.end-default-notification-box-normal {{
    background-color: {bar_bg};
    padding: 12px;
    padding-left: 8px;
    margin: 12px;
    border-radius: 10px;
}}

.end-default-notification-box-critical {{
    background-color: {bar_bg};
    padding: 12px;
    padding-left: 8px;
    margin: 12px;
    border-radius: 10px;
    border: 2px solid #ff0000;
}}

.end-default-notification-title-bar {{
    background-color: {bar_bg};
    margin: 3px;
    border-bottom: 1px solid {bar_border};
}}

.end-default-notification-appicon {{
    margin-right: 10px;
    margin-bottom: 5px;
}}

.end-default-notification-appname {{
    color: {bar_fg};
    margin-right: 12px;
    font-family: 'JetBrainsMono Nerd Font';
    font-weight: bold;
    font-size: 15px;
}}

.end-default-notification-body-box {{
    margin-top: 12px;
}}

.notification-text {{
    color: {bar_fg};
    font-family: 'JetBrainsMono Nerd Font';
}}

.notification-title {{
  font-weight: bold;
  font-size: 1em;
}}

.notification-content {{
  font-size: .8em;
}}

.end-notification-buttons {{
    margin-top: 12px;
}}

.end-notification-button {{
    background-color: {bar_bg};
    color: {bar_fg};
    padding: 8px;
    border-radius: 10px;
    margin-right: 12px;
    border: 1px solid {bar_border};
}}

.end-notification-reply {{
    background-color: {bar_bg};
    color: {bar_fg};
    padding: 8px;
    border-radius: 10px;
    margin-right: 12px;
    border: 1px solid {bar_border};
}}

.end-notification-reply:hover:focus {{
    background-color: {bar_fg};
    color: {hourcolor};
    padding: 8px;
    border-radius: 10px;
    margin-right: 12px;
    border: 1px solid {bar_border};
}}

.end-notification-button:hover {{
    background-color: {bar_fg};
    color: {bar_bg};
    padding: 8px;
    border-radius: 10px;
    margin-right: 12px;
    border: 1px solid {bar_border};
}}

.end-history-frame {{
    background-color: {bar_bg};
    padding: 12px;
    padding-left: 8px;
    border-radius: 10px;
}}

.end-history-box {{
    background-color: {bar_bg};
    padding: 12px;
    padding-left: 8px;
    border: 1px solid {bar_border};
}}

.end-history-title-bar {{
    background-color: {bar_bg};
    margin: 1px;
    border-bottom: 1px solid {bar_border};
}}

.end-history-appicon {{
    margin-right: 5px;
    margin-bottom: 2px;
}}

.end-history-appname {{
    color: {bar_fg};
    margin-right: 5px;
    font-family: 'JetBrainsMono Nerd Font';
    font-weight: bold;
    font-size: 10px;
}}

.end-history-body-box {{
    margin-top: 3px;
}}

.content-box {{
    margin-left: 12px;
}}

.battery-icon {{
    color: rgb(255, 0, 0);
    font-size: 2.1em;
    margin-right: 48px;
    margin-left: 24px;
}}

.tray menu {{
    border-radius: 0px;
    border: 1px solid {bar_border};
    padding: 5px 0px;
    background-color: {bar_bg};
}}

.tray menu > menuitem {{
    padding: 0px 5px;
}}

.tray menu > menuitem:disabled label {{
    color: gray;
}}

.tray menu > menuitem:hover {{
    background-color: {bar_fg_hover};
}}

.tray menu separator {{
    background-color: {bar_border};
    padding-top: 1px;
}}

.tray menu separator:last-child {{
    padding: unset;
}}"""

print(css)
