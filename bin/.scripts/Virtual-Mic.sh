#!/usr/bin/env bash

createMic(){
	touch /tmp/vmic-lock
	
	# Create a virtual sink that can be set as a monitor in OBS
	pactl load-module module-null-sink sink_name=VirtualSpeaker sink_properties=device.description=VirtualSpeaker
	# Link it with a virtual source that is visible in pulseaudio apps like Zoom
	pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=VirtualMic channel_map=front-left,front-right
}

linkMic(){
	touch /tmp/vmic-link-lock	
	
	pw-link VirtualSpeaker:monitor_FL VirtualMic:input_FL
	pw-link VirtualSpeaker:monitor_FR VirtualMic:input_FR
}
if ! [ -f /tmp/vmic-lock ]; then createMic ; else echo "Virtaul Mic already working"; fi
if ! [ -f /tmp/vmic-link-lock ]; then linkMic ; else echo "Virtaul Mic already linked"; fi

