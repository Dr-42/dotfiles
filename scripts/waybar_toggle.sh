#!/bin/bash

while true; do
  # Get the cursor position
  cursor_pos=$(hyprctl cursorpos)
  x_pos=$(echo $cursor_pos | cut -d ',' -f 1)
  y_pos=$(echo $cursor_pos | cut -d ',' -f 2)

  # Function to check if Waybar is running
  is_waybar_running() {
    pgrep -x waybar > /dev/null
  }

  # Check the y position and toggle Waybar accordingly
  if [ $y_pos -gt 30 ]; then
    if is_waybar_running; then
      killall waybar
    fi
  else
    if ! is_waybar_running; then
      waybar &
    fi
  fi
done
