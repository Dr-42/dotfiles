#!/bin/sh
pkill conky
sleep 2
color1=$(sed -n 4p ~/.cache/wal/colors)
color2=$(sed -n 10p ~/.cache/wal/colors)

sed -i "s|color4 =.*$|color4 = '$color1',|g" ~/.config/conky/conkyrc.lua
sed -i "s|color5 =.*$|color5 = '$color2',|g"  ~/.config/conky/conkyrc.lua

conky -c ~/.config/conky/conkyrc.lua &
conky -c ~/.config/conky/conky.conf &
