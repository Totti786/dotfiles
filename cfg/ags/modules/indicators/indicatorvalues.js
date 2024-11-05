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
    return Box({
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
    const volumeIndicator = OsdValue({
	    name: 'Volume',
	    extraClassName: 'osd-volume',
	    extraProgressClassName: 'osd-volume-progress',
	    attribute: { headphones: undefined , device: undefined },
	    nameSetup: (self) => {
	        // Update device label based on audio output
	        const updateAudioDevice = () => {
	            const usingHeadphones = (Audio.speaker?.stream?.port)?.toLowerCase().includes('headphone');
	            const usingHeadset = (Audio.speaker?.stream?.port)?.toLowerCase().includes('headset');
	            if (volumeIndicator.attribute.headphones !== usingHeadphones) {
	                volumeIndicator.attribute.headphones = usingHeadphones;
	                self.label = usingHeadphones ? 'Headphones' : 'Speakers';
	            }
	            if (volumeIndicator.attribute.headphones !== usingHeadset) {
	                volumeIndicator.attribute.headphones = usingHeadset;
	                self.label = usingHeadset ? 'Headset' : 'Speakers';
	            }
	        };
	        self.hook(Audio, updateAudioDevice);
	        Utils.timeout(1000, updateAudioDevice); // Initial check after 1 second
	    },
	    labelSetup: (self) => {
	        const updateVolume = () => {
	            const newDevice = (Audio.speaker?.name);
	            const updateValue = Math.round(Audio.speaker?.volume * 100);
	            if (!isNaN(updateValue)) {
	                if (newDevice === volumeIndicator.attribute.device && updateValue !== self.label) {
	                    Indicator.popup(1); // Show the popup if the value changed
	                }
	            }
	            volumeIndicator.attribute.device = newDevice;
	            self.label = `${updateValue}`; // Update label with current volume
	        };
	        self.hook(Audio, updateVolume); // Hook into the Audio service for updates
	    },
	    progressSetup: (self) => {
	        const updateProgress = () => {
	            const updateValue = Audio.speaker?.volume;
	            if (!isNaN(updateValue)) {
	                self.value = Math.min(updateValue, 1); // Ensure value does not exceed 1
	            }
	        };
	        self.hook(Audio, updateProgress);
	    },
	});
	
    const brightnessIndicator = OsdValue({
        name: 'Brightness',
        extraClassName: 'osd-brightness',
        extraProgressClassName: 'osd-brightness-progress',
        labelSetup: (self) => {
            BrightnessService.connect('screen-changed', () => {
                const newLabel = Math.round(BrightnessService.screen_value * 100);
                if (self.label !== newLabel) {
                    self.label = `${newLabel}`;
                }
            });
        },
        progressSetup: (self) => {
            BrightnessService.connect('screen-changed', () => {
                const updateValue = BrightnessService.screen_value;
                if (self.value !== updateValue) {
                    Indicator.popup(1);
                    self.value = updateValue;
                }
            });
        },
    });
    
    return MarginRevealer({
        transition: 'slide_down',
        showClass: 'osd-show',
        hideClass: 'osd-hide',
        extraSetup: (self) => self
            .hook(Indicator, (revealer, value) => {
                if (value > -1) revealer.attribute.show();
                else revealer.attribute.hide();
            }, 'popup'),
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
