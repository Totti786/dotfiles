#!/bin/bash

VDIR="$HOME/Videos/TimeLapse"
SDIR="$HOME/Pictures/Screenshots/Temp"
Name=$(date +'%m-%d-%Y-%A') 
File="$VDIR/$Name.mp4"

# Created a timelaspe of the screenshots taken by the screenshot scripts
createVideo(){
	cd $VDIR
	ffmpeg -framerate 10 -pattern_type glob -i "$SDIR/*.png" \
	-s:v 1920x1080 -c:v libx264 -crf 17 -pix_fmt yuv420p $Name.mp4 
}
# Deletes all the screen shot from the directory
deleteScreenshots(){
	cd $SDIR && rm *.png
}

checkFile(){
	# Check if the video file has been created
	if [[ -f "$File" ]]; then
		deleteScreenshots
		echo "Deleted files"
	 else 
		echo "Video File not found"
	fi
}
# checks if the video directory exists and if not it creates one then excutes 
main(){
if [ -d "$VDIR" ]; then
   # Take action if $DIR exists. #
   createVideo &&
   checkFile
  else 
   # Create directory and then take action
   mkdir $VDIR
   createVideo &&
   checkFile
fi
}

if command -v ffmpeg &> /dev/null; then 
	main	
fi
