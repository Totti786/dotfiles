#!/usr/bin/env bash

current_day=$(date +'%m-%d-%Y-%A')
temp_dir="$HOME/Pictures/Screenshots/Temp"
ffmpeg_config=(-vaapi_device /dev/dri/renderD128 -vcodec hevc_vaapi -vf 'format=nv12|vaapi,hwupload')
video_dir="$HOME/Videos/TimeLapse"

# Iterate through each directory in the parent directory
for daily_dir in "$temp_dir"/*; do
	# Extract the directory name (without the path)
	dir_name=$(basename "$daily_dir")

	# Check if the directory is not for the current day
	if [[ "$dir_name" != "$current_day" ]]; then
		# Create a time-lapse video using ffmpeg
		ffmpeg -framerate 10 -pattern_type glob -i "$daily_dir/*.png"  ${ffmpeg_config[@]} "$video_dir/$dir_name.mp4"

		# Check if the video file was created successfully
		if [ -f "$video_dir/$dir_name.mp4" ]; then
			# Optionally, delete the images in the directory
			rm -R "$daily_dir"
		fi
	fi
done
