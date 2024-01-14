# Get all the images from the folder and set a random one as wallpaper

# Renew hyprpaper conf
eval "mv ~/.config/hypr/hyprpaper.conf ~/.config/hypr/hyprpaper.conf.bak"

# Get the images from the folder
for image in $HOME/dotfiles/Wallpapers/*; do
  images+=("$(basename "$image")")
  echostring="preload = $image"
  echo "$echostring" >> ~/.config/hypr/hyprpaper.conf
  echo "$echostring"
done

# Get the number of images
n_images=${#images[@]}

while true; do
  # Get a random number
  random_number=$((RANDOM % $n_images))

  # Get the image
  # Image path may have spaces
  image="${images[$random_number]}"
  echo "Setting $image as wallpaper"

  # Set the wallpaper
  path="$HOME/dotfiles/Wallpapers/$image"
  echo "Path: $path"
  cmd="hyprctl hyprpaper wallpaper eDP-1,\"$path\""
  eval $cmd
  sleep 600
done
