// This is for the right pills of the bar.
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
const { Box, Label, Button, Overlay, Revealer, Scrollable, Stack, EventBox } = Widget;
const { exec, execAsync } = Utils;
const { GLib } = imports.gi;
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import { MaterialIcon } from '../../.commonwidgets/materialicon.js';
import { AnimatedCircProg } from "../../.commonwidgets/cairo_circularprogress.js";
import { WWO_CODE, WEATHER_SYMBOL, NIGHT_WEATHER_SYMBOL } from '../../.commondata/weather.js';

const WEATHER_CACHE_FOLDER = `${GLib.get_user_cache_dir()}/ags/weather`;
Utils.exec(`mkdir -p ${WEATHER_CACHE_FOLDER}`);

const BarBatteryProgress = () => {
    const _updateProgress = (circprog) => { // Set circular progress value
        circprog.css = `font-size: ${Math.abs(Battery.percent)}px;`

        circprog.toggleClassName('bar-batt-circprog-low', Battery.percent <= userOptions.battery.low);
        circprog.toggleClassName('bar-batt-circprog-full', Battery.charged);
    }
    return AnimatedCircProg({
        className: 'bar-batt-circprog',
        vpack: 'center', hpack: 'center',
        extraSetup: (self) => self
            .hook(Battery, _updateProgress)
        ,
    })
}

const time = Variable('', {
    poll: [
        userOptions.time.interval,
        () => GLib.DateTime.new_now_local().format(userOptions.time.format),
    ],
})

const date = Variable('', {
    poll: [
        userOptions.time.dateInterval,
        () => GLib.DateTime.new_now_local().format(userOptions.time.dateFormatLong),
    ],
})

const BarClock = () => Widget.Box({
    vpack: 'center',
    className: 'spacing-h-4 bar-clock-box',
    child: Widget.EventBox({
        onSecondaryClick: () => openColorScheme.setValue(!openColorScheme.value),
	    child: Widget.Box({
			hpack: 'start',
		    children: [
		        Widget.Label({
		            className: 'bar-time',
		            label: time.bind(),
		        }),
		        Widget.Label({
		            className: 'txt-norm txt-onLayer1',
		            label: '•',
		        }),
		        Widget.Label({
		            className: 'txt-smallie bar-date',
		            label: date.bind(),
		        }),
		    ],
		}),
	}),
});


const checkRecordingStatus = async () => {
    try {
        const result = await Utils.execAsync('recorder --status');
        return result.trim(); // off, paused, or on
    } catch (error) {
        print(error);
        return 'off'; // Default to off if there's an error
    }
};

const UtilButton = ({ name, icon, onClicked, onSecondaryClick }) => Button({
    vpack: 'center',
    tooltipText: name,
    onClicked: onClicked,
    onSecondaryClick: onSecondaryClick,
    className: 'bar-util-btn icon-material txt-norm',
    label: `${icon}`,
});

const Utilities = () => {
    let recordingStatus = 'off';
    let icon = 'screen_record';
    let statusInterval = null; // To store the interval ID

    const updateStatus = async () => {
        try {
            const newStatus = await checkRecordingStatus();
            if (newStatus !== recordingStatus) {
                recordingStatus = newStatus;
                console.log(`Recording status changed to: ${recordingStatus}`); // Debug log

                if (recordingStatus === 'on') {
                    icon = 'radio_button_checked';
                    if (!statusInterval) {
                        statusInterval = setInterval(updateStatus, 500); // Start the interval when recording starts
                    }
                } else if (recordingStatus === 'paused') {
                    icon = 'motion_photos_paused';
                    if (!statusInterval) {
                        statusInterval = setInterval(updateStatus, 500); // Start the interval when recording is paused
                    }
                } else {
                    icon = 'screen_record';
                    if (statusInterval) {
                        clearInterval(statusInterval); // Stop the interval when recording stops
                        statusInterval = null;
                    }
                }

                // Debug log to verify icon update
                console.log(`Updating button icon to: ${icon}`);
                screenRecorderButton.label = icon;
            }
        } catch (error) {
            console.error('Error updating status:', error); // Debug log for errors
        }
    };

    // Initial status check
    updateStatus();

    const screenSnipButton = UtilButton({
        name: 'Screen snip',
        icon: 'screenshot_region',
        onClicked: () => {
            Utils.execAsync('shot --area').catch(print);
        },
        onSecondaryClick: () => {
            Utils.execAsync('shot --now').catch(print);
        }
    });

    const colorPickerButton = UtilButton({
        name: 'Color picker',
        icon: 'colorize',
        onClicked: () => {
            Utils.execAsync(['color-picker']).catch(print);
        },
        onSecondaryClick: () => {
            Utils.execAsync(['color-picker']).catch(print);
        }
    });

    const screenRecorderButton = UtilButton({
        name: 'Screen Recorder',
        icon: icon,
        onClicked: async () => {
            if (recordingStatus === 'on' || recordingStatus === 'paused') {
                Utils.execAsync('recorder --stop').catch(print);
            } else {
                Utils.execAsync('recorder --screen').catch(print);
                statusInterval = setInterval(updateStatus, 500); // Start the interval when recording starts
            }
        },
        onSecondaryClick: async () => {
            if (recordingStatus === 'on' || recordingStatus === 'paused') {
                Utils.execAsync('recorder --toggle').catch(print);
            } else {
                Utils.execAsync('recorder --stop').catch(print);
            }
        }
    });

    return Box({
        hpack: 'right',
        className: 'spacing-h-4',
        children: [
            screenSnipButton,
            colorPickerButton,
            screenRecorderButton
        ]
    });
};


const BarBattery = () => {
    const batteryCircProg = AnimatedCircProg({
        className: 'bar-batt-circprog',
        vpack: 'center',
        hpack: 'center',
    });
    const batteryProgress = Box({
        homogeneous: true,
        children: [Overlay({
            child: Box({
                vpack: 'center',
                className: 'bar-batt',
                homogeneous: true,
                children: [
                    MaterialIcon('battery_full', 'small'),
                ],
            }),
            overlays: [batteryCircProg]
        })]
    });
    const batteryLabel = Label({
        className: 'txt-smallie txt-onSurfaceVariant',
    });
    const widget = Box({
        className: 'spacing-h-4 bar-batt-txt',
        children: [
            Revealer({
                transitionDuration: userOptions.animations.durationSmall,
                revealChild: false,
                transition: 'slide_right',
                child: MaterialIcon('bolt', 'norm', { tooltipText: "Charging" }),
                setup: (self) => self.hook(Battery, revealer => {
                    self.revealChild = Battery.charging;
                }),
            }),
            batteryProgress,
            batteryLabel,
        ],
        setup: (self) => self.poll(5000, () => execAsync(['bash', '-c', `acpi | awk '{print $5}' | cut -d ":" -f1-2`])
            .then((output) => {
                const remainingTime = output.trim();
                batteryLabel.label = `${Number.parseFloat(Battery.percent.toFixed(1))}%`;
                widget.tooltipText = remainingTime || "Unknown remaining time";
                batteryCircProg.css = `font-size: ${Battery.percent}px;`; // Example of using Battery.percent dynamically.
            }).catch((err) => {
                print(err);
                widget.tooltipText = "Error fetching battery time";
            }))
    });

    return widget;
};

const WeatherModule = () => Widget.Box({
		hexpand: true,
		hpack: 'center',
		className: 'spacing-h-4 txt-onSurfaceVariant',
		children: [
			MaterialIcon('device_thermostat', 'small'),
			Label({
				label: 'Weather',
			})
		],
		setup: (self) => self.poll(900000, async (self) => {
			const WEATHER_CACHE_PATH = WEATHER_CACHE_FOLDER + '/wttr.in.txt';
			const updateWeatherForCity = (city) => execAsync(`curl https://wttr.in/${city.replace(/ /g, '%20')}?format=j1`)
				.then(output => {
					const weather = JSON.parse(output);
					Utils.writeFile(JSON.stringify(weather), WEATHER_CACHE_PATH)
						.catch(print);
					const weatherCode = weather.current_condition[0].weatherCode;
					const weatherDesc = weather.current_condition[0].weatherDesc[0].value;
					const temperature = weather.current_condition[0].temp_C;
					const feelsLike = weather.current_condition[0].FeelsLikeC;
					const weatherSymbol = WEATHER_SYMBOL[WWO_CODE[weatherCode]];
					self.children[0].label = weatherSymbol;
					self.children[1].label = `${temperature}℃ • Feels like ${feelsLike}℃`;
					self.tooltipText = weatherDesc;
				}).catch((err) => {
					try { // Read from cache
						const weather = JSON.parse(
							Utils.readFile(WEATHER_CACHE_PATH)
						);
						const weatherCode = weather.current_condition[0].weatherCode;
						const weatherDesc = weather.current_condition[0].weatherDesc[0].value;
						const temperature = weather.current_condition[0].temp_C;
						const feelsLike = weather.current_condition[0].FeelsLikeC;
						const weatherSymbol = WEATHER_SYMBOL[WWO_CODE[weatherCode]];
						self.children[0].label = weatherSymbol;
						self.children[1].label = `${temperature}℃ • Feels like ${feelsLike}℃`;
						self.tooltipText = weatherDesc;
					} catch (err) {
						print(err);
					}
				});
			if (userOptions.weather.city != '' && userOptions.weather.city != null) {
				updateWeatherForCity(userOptions.weather.city.replace(/ /g, '%20'));
			}
			else {
				Utils.execAsync('curl ifconfig.co/json')
					.then(output => {
						return JSON.parse(output)['city'].toLowerCase();
					})
					.then(updateWeatherForCity)
					.catch(print)
			}
		}),
});

const BarGroup = ({ child }) => Widget.Box({
    className: 'bar-group-margin bar-sides',
    children: [
        Widget.Box({
            className: 'bar-group bar-group-standalone bar-group-pad-system',
            children: [child],
        }),
    ]
});
const BatteryModule = () => Stack
(
	{
	    transition: 'slide_up_down',
	    transitionDuration: userOptions.animations.durationLarge,
	    children: {
	        'laptop': Box({
	            className: 'spacing-h-4', children: [
	                BarGroup({ child: Utilities() }),
	                BarGroup({ child: BarBattery() }),
	                BarGroup({ child: WeatherModule() }),
	            ]
	        }),
	        'desktop':  Box({
	            className: 'spacing-h-4', children: [
	                BarGroup({ child: Utilities() }),
	                BarGroup({ child: WeatherModule() }),
	            ]
	        }),
	    },
	    setup: (stack) => Utils.timeout(10, () => {
	        if (!Battery.available) stack.shown = 'desktop';
	        else stack.shown = 'laptop';
	    })
	}
)

const switchToRelativeWorkspace = async (self, num) => {
    try {
        const Hyprland = (await import('resource:///com/github/Aylur/ags/service/hyprland.js')).default;
        Hyprland.messageAsync(`dispatch workspace r${num > 0 ? '+' : ''}${num}`).catch(print);
    } catch {
        execAsync([`${App.configDir}/scripts/sway/swayToRelativeWs.sh`, `${num}`]).catch(print);
    }
}

export default () => Widget.EventBox({
    onScrollUp: (self) => switchToRelativeWorkspace(self, -1),
    onScrollDown: (self) => switchToRelativeWorkspace(self, +1),
    onPrimaryClick: () => App.toggleWindow('sideright'),
    child: Widget.Box({
        className: 'spacing-h-4',
        children: [
            BarGroup({ child: BarClock() }),
            BatteryModule(),
        ]
    })
});
