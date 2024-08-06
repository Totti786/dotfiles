player="mpv"
base="flixhq.to"
provider="Vidcloud"
quality=1080
subs_language="English"
use_external_menu="true"
history="true"
download_dir="$PWD"
image_preview="true"
quiet_output="false"
preview_window_size=50%
remove_tmp_lobster="false"
json_output="false"
discord_presence="false"
debug="false"
image_config_path="$HOME/.config/rofi/themes/rofi-media.rasi"
histfile="$HOME/.local/share/lobster/lobster_history.txt"

download_video() {
  ffmpeg -loglevel error -stats -i "$1" -c copy "$3/$2".mp4
}
