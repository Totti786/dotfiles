#! /bin/bash

DIR="$HOME/Pictures/Screenshots/Temp"

takeshot(){
	cd $DIR
	while true; do scrot -q 70 & sleep 45; done
}

main(){
if [ -d "$DIR" ]; then
   # Take action if $DIR exists. #
   	takeshot &
	echo "Running Script"
  else 
   # Create Directory and then take action
   mkdir $DIR &&
   	takeshot &
	echo "Running Script"
fi
}

if command -v scrot &> /dev/null; then 
	main
fi
