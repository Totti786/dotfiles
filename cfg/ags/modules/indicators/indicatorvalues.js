// This file is for brightness/volume indicators
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
const { Box, Label, ProgressBar } = Widget;
import { MarginRevealer } from '../.widgethacks/advancedrevealers.js';
import BrightnessService from '../../services/brightness.js';
import Indicator from '../../services/indicator.js';

const OsdValue = ({
    name, nameSetup = undefined, labelSetup, progressSetup,
    extraClassName = '', extraProgressClassName = '',
    ...rest
}) => {
    const valueName = Label({
        xalign: 0, yalign: 0, hexpand: true,
        className: 'osd-label',
        label: `${name}`,
        setup: nameSetup,
    });
    const valueNumber = Label({
        hexpand: false, className: 'osd-value-txt',
        setup: labelSetup,
    });
    return Box({ // Volume
        vertical: true,
        hexpand: true,
        className: `osd-bg osd-value ${extraClassName}`,
        attribute: {
            'disable': () => {
                valueNumber.label = '󰖭';
            }
        },
        children: [
            Box({
                vexpand: true,
                children: [
                    valueName,
                    valueNumber,
                ]
            }),
            ProgressBar({
                className: `osd-progress ${extraProgressClassName}`,
                hexpand: true,
                vertical: false,
                setup: progressSetup,
            })
        ],
        ...rest,
    });
}

export default () => {
    const brightnessIndicator = OsdValue({
        name: 'Brightness',
        extraClassName: 'osd-brightness',
        extraProgressClassName: 'osd-brightness-progress',
        labelSetup: (self) => {
            BrightnessService.connect('notify::screen-value', () => {
                self.label = `${Math.round(BrightnessService.screen_value * 100)}`;
            });
        },
        progressSetup: (self) => {
            BrightnessService.connect('notify::screen-value', () => {
                const updateValue = BrightnessService.screen_value;
                if (updateValue !== self.value) Indicator.popup(1);
                self.value = updateValue;
            });
        },
    });

	let lastVolume = null;
	let lastMuteState = null;
	
	const volumeIndicator = OsdValue({
	    name: 'Volume',
	    extraClassName: 'osd-volume',
	    extraProgressClassName: 'osd-volume-progress',
	    attribute: { headphones: undefined, device: undefined },
	    nameSetup: (self) => Utils.timeout(1, () => {
	        const updateAudioDevice = () => {
	            const usingHeadphones = (Audio.speaker?.stream?.port)?.toLowerCase().includes('headphone');
	            const usingHeadset = (Audio.speaker?.stream?.port)?.toLowerCase().includes('headset');
	            if (volumeIndicator.attribute.headphones === undefined ||
	                volumeIndicator.attribute.headphones !== usingHeadphones) {
	                volumeIndicator.attribute.headphones = usingHeadphones;
	                self.label = usingHeadphones ? 'Headphones' : 'Speakers';
	            }
	            if (volumeIndicator.attribute.headphones === undefined ||
	                volumeIndicator.attribute.headphones !== usingHeadset) {
	                volumeIndicator.attribute.headphones = usingHeadset;
	                self.label = usingHeadset ? 'Headset' : 'Speakers';
	            }
	        }
	        self.hook(Audio, updateAudioDevice);
	        Utils.timeout(1000, updateAudioDevice);
	    }),
	    labelSetup: (self) => self.hook(Audio, (label) => {
	        const newDevice = Audio.speaker?.name;
	        const updateValue = Math.round(Audio.speaker?.volume * 100);
	        const isMuted = Audio.speaker?.isMuted || updateValue === 0;
	
	        // Log values to debug
	        console.log(`Volume: ${updateValue}, Muted: ${isMuted}`);
	
	        // Set label to "Muted" or show the actual volume percentage
	        label.className = isMuted ? 'osd-value-icon icon-material' : "osd-value-txt";
	        label.label = isMuted ? 'volume_off' : `${updateValue}`;
	
	        // Check if volume or mute state has changed
	        const volumeChanged = updateValue !== lastVolume;
	        const muteStateChanged = isMuted !== lastMuteState;
	
	        if (volumeChanged || muteStateChanged) {
	            // Trigger the popup only if there was a change in volume or mute state
	            Indicator.popup(1);
	        }
	
	        // Update the stored state
	        lastVolume = updateValue;
	        lastMuteState = isMuted;
	
	        volumeIndicator.attribute.device = newDevice;
	    }),
	    progressSetup: (self) => self.hook(Audio, (progress) => {
	        const updateValue = Audio.speaker?.volume;
	        const isMuted = Audio.speaker?.isMuted || updateValue === 0;
	
	        // Log values to debug
	        console.log(`Progress Value: ${isMuted ? 0 : updateValue}`);
	
	        // Update progress bar: 0 if muted, actual volume otherwise
	        progress.value = isMuted ? 0 : (updateValue > 1 ? 1 : updateValue);
	    }),
	});

    return MarginRevealer({
        transition: 'slide_down',
        showClass: 'osd-show',
        hideClass: 'osd-hide',
        extraSetup: (self) => self
            .hook(Indicator, (revealer, value) => {
                if (value > -1) revealer.attribute.show();
                else revealer.attribute.hide();
            }, 'popup')
        ,
        child: Box({
            hpack: 'center',
            vertical: false,
            className: 'spacing-h--10',
            children: [
                brightnessIndicator,
                volumeIndicator,
            ]
        })
    });
}
