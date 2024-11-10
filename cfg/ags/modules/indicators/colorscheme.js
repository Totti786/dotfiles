const { Gio, GLib } = imports.gi;
import Variable from 'resource:///com/github/Aylur/ags/variable.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { ConfigToggle, ConfigMulipleSelection } from '../.commonwidgets/configwidgets.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
const { execAsync } = Utils;
import { setupCursorHover } from '../.widgetutils/cursorhover.js';
import { showColorScheme } from '../../variables.js';
import { MaterialIcon } from '../.commonwidgets/materialicon.js';
import { darkMode } from '../.miscutils/system.js';

const ColorBox = ({
    name = 'Color',
    ...rest
}) => Widget.Box({
    ...rest,
    homogeneous: true,
    children: [
        Widget.Label({
            label: `${name}`,
        })
    ]
})

const ColorSchemeSettingsRevealer = () => {
    const headerButtonIcon = MaterialIcon('expand_more', 'norm');
    const header = Widget.Button({
        className: 'osd-settings-btn-arrow',
        onClicked: () => {
            content.revealChild = !content.revealChild;
            headerButtonIcon.label = content.revealChild ? 'expand_less' : 'expand_more';
        },
        setup: setupCursorHover,
        hpack: 'end',
        child: headerButtonIcon,
    });
    const content = Widget.Revealer({
        revealChild: false,
        transition: 'slide_down',
        transitionDuration: 200,
        child: ColorSchemeSettings(),
        setup: (self) => self.hook(isHoveredColorschemeSettings, (revealer) => {
            if (isHoveredColorschemeSettings.value == false) {
                setTimeout(() => {
                    if (isHoveredColorschemeSettings.value == false)
                        revealer.revealChild = false;
                    headerButtonIcon.label = 'expand_more';
                }, 1500);
            }
        }),
    });
    return Widget.EventBox({
        onHover: (self) => {
            isHoveredColorschemeSettings.setValue(true);
        },
        onHoverLost: (self) => {
            isHoveredColorschemeSettings.setValue(false);
        },
        child: Widget.Box({
            vertical: true,
            children: [
                header,
                content,
            ]
        }),
    });
}

function calculateSchemeInitIndex(optionsArr, searchValue = 'vibrant') {
    if (searchValue == '')
        searchValue = 'vibrant';
    const flatArray = optionsArr.flatMap(subArray => subArray);
    const result = flatArray.findIndex(element => element.value === searchValue);
    const rowIndex = Math.floor(result / optionsArr[0].length);
    const columnIndex = result % optionsArr[0].length;
    return [rowIndex, columnIndex];
}

const schemeOptionsArr = [
    [
        { name: getString('Tonal Spot'), value: 'tonalspot' },
        { name: getString('Fruit Salad'), value: 'fruitsalad' },
        { name: getString('Fidelity'), value: 'fidelity' },
        { name: getString('Rainbow'), value: 'rainbow' },
    ],
    [
        { name: getString('Neutral'), value: 'neutral' },
        { name: getString('Monochrome'), value: 'monochrome' },
        { name: getString('Expressive'), value: 'expressive' },
        { name: getString('Vibrant'), value: 'vibrant' },
    ],
    [
        { name: getString('Vibrant+'), value: 'morevibrant' },
    ],
    //[
    //  { name: getString('Content'), value: 'content' },
    //]
];

const LIGHTDARK_FILE_LOCATION = `${GLib.get_user_state_dir()}/ags/user/colormode.txt`;
const BACKEND_FILE_LOCATION = `${GLib.get_user_state_dir()}/ags/user/colorbackend.txt`;
const initColorMode = Utils.exec(`bash -c "sed -n \'1p\' ${LIGHTDARK_FILE_LOCATION}"`);
const initColorVal = (initColorMode == "dark") ? 1 : 0;
const initTransparency = Utils.exec(`bash -c "sed -n \'2p\' ${LIGHTDARK_FILE_LOCATION}"`);
const initTransparencyVal = (initTransparency == "transparent") ? 1 : 0;
const initBackend = Utils.exec(`bash -c "sed -n \'1p\' ${BACKEND_FILE_LOCATION}"`);
const initBackendVal = (initBackend == "material") ? 1 : 0;
const initScheme = Utils.exec(`bash -c "sed -n \'3p\' ${LIGHTDARK_FILE_LOCATION}"`);
const initSchemeIndex = calculateSchemeInitIndex(schemeOptionsArr, initScheme);

const ColorSchemeSettings = () => {
    let childRevealer;

    return Widget.Box({
        className: 'osd-colorscheme-settings spacing-v-5',
        vertical: true,
        vpack: 'center',
        children: [
            Widget.Box({
	            vertical: true,
                children: [
	                Widget.Label({
	                    xalign: 0,
	                    className: 'txt-norm titlefont txt',
			    label: getString('Options'),
	                    hpack: 'center',
	                }),
	                ConfigToggle({
	                    icon: 'border_clear',
	                    name: 'Transparency',
	                    desc: 'Make shell elements transparent',
	                    initValue: initTransparencyVal,
	                    onChange: (self, newValue) => {
	                        let transparency = newValue == 0 ? "opaque" : "transparent";
	                        execAsync([`bash`, `-c`, `mkdir -p ${GLib.get_user_state_dir()}/ags/user && sed -i "2s/.*/${transparency}/" ${LIGHTDARK_FILE_LOCATION}`])
	                            .then(execAsync(['bash', '-c', `${App.configDir}/scripts/color_generation/switchcolor.sh`]))
	                            .catch(print);
	                    },
	                }),
		           ConfigToggle({
   						icon: 'palette',
		                name: 'Material Backend',
	                    desc: 'Toggle between pywal and material colors',
		                initValue: initBackendVal,
		                onChange: (self, newValue) => {
		                    let backend = newValue == 0 ? "pywal" : "material";
		                    execAsync([`bash`, `-c`, `mkdir -p ${GLib.get_user_state_dir()}/ags/user && sed -i "1s/.*/${backend}/" ${BACKEND_FILE_LOCATION}`])
		                        .then(execAsync(['bash', '-c', `${App.configDir}/scripts/color_generation/switchcolor.sh`]))
		                        .then(() => {
									childRevealer.revealChild = newValue === true;                            
		                        })
		                        .catch(print);
		                },
		            }),			
                ]
            }),
            Widget.Revealer({
                transition: 'slide_down',
                transitionDuration: 500,
                child: Widget.Box({
			        vertical: true,
                    children: [
						ConfigToggle({
	                        icon: 'dark_mode',
							name: 'Dark Mode',
							desc: 'Ya should go to sleep!',
	                        initValue: initColorVal,
	                        onChange: (self, newValue) => {
	                            let lightdark = newValue == 0 ? "light" : "dark";
                   		    execAsync([`bash`, `-c`, `mkdir -p ${GLib.get_user_state_dir()}/ags/user && sed -i "1s/.*/${lightdark}/" ${LIGHTDARK_FILE_LOCATION}`])
	                                .then(execAsync(['bash', '-c', `${App.configDir}/scripts/color_generation/switchcolor.sh`]))
	                                .catch(print);
	                        },
						}),
		                Widget.Label({
		                    xalign: 0,
		                    className: 'txt-norm titlefont txt margin-top-5',
		                    label: 'Scheme styles',
		                    hpack: 'center',
		                }),
		                ConfigMulipleSelection({
		                    hpack: 'center',
		                    vpack: 'center',
		                    optionsArr: schemeOptionsArr,
		                    initIndex: initSchemeIndex,
		                    onChange: (value, name) => {
		                        execAsync([`bash`, `-c`, `mkdir -p ${GLib.get_user_state_dir()}/ags/user && sed -i "3s/.*/${value}/" ${LIGHTDARK_FILE_LOCATION}`])
		                            .then(execAsync(['bash', '-c', `${App.configDir}/scripts/color_generation/switchcolor.sh`]))
		                            .catch(print);
		                    },
		                }),
                    ]
                }),
                setup: (self) => {
                    childRevealer = self;
                    self.revealChild = initBackendVal === 1; 
                }
            }),
        ],
    });
};


const ColorschemeContent = () => Widget.Box({
    className: 'osd-colorscheme spacing-v-5',
    vertical: true,
    hpack: 'center',
    children: [
        Widget.Label({
            xalign: 0,
            className: 'txt-norm titlefont txt',
            label: getString('Color scheme'),
            hpack: 'center',
        }),
        Widget.Box({
            className: 'spacing-h-5',
            hpack: 'center',
            children: [
                ColorBox({ name: 'P', className: 'osd-color osd-color-primary' }),
                ColorBox({ name: 'S', className: 'osd-color osd-color-secondary' }),
                ColorBox({ name: 'T', className: 'osd-color osd-color-tertiary' }),
                ColorBox({ name: 'Sf', className: 'osd-color osd-color-surface' }),
                ColorBox({ name: 'Sf-i', className: 'osd-color osd-color-inverseSurface' }),
                ColorBox({ name: 'E', className: 'osd-color osd-color-error' }),
            ]
        }),
        Widget.Box({
            className: 'spacing-h-5',
            hpack: 'center',
            children: [
                ColorBox({ name: 'P-c', className: 'osd-color osd-color-primaryContainer' }),
                ColorBox({ name: 'S-c', className: 'osd-color osd-color-secondaryContainer' }),
                ColorBox({ name: 'T-c', className: 'osd-color osd-color-tertiaryContainer' }),
                ColorBox({ name: 'Sf-c', className: 'osd-color osd-color-surfaceContainer' }),
                ColorBox({ name: 'Sf-v', className: 'osd-color osd-color-surfaceVariant' }),
                ColorBox({ name: 'E-c', className: 'osd-color osd-color-errorContainer' }),
            ]
        }),
        ColorSchemeSettingsRevealer(),
    ]
});

const isHoveredColorschemeSettings = Variable(false);

export default () => Widget.Revealer({
    transition: 'slide_down',
    transitionDuration: userOptions.animations.durationLarge,
    child: ColorschemeContent(),
    setup: (self) => {
        self
            .hook(showColorScheme, (revealer) => {
                if (showColorScheme.value == true)
                    revealer.revealChild = true;
                else
                    revealer.revealChild = isHoveredColorschemeSettings.value;
            })
            .hook(isHoveredColorschemeSettings, (revealer) => {
                if (isHoveredColorschemeSettings.value == false) {
                    setTimeout(() => {
                        if (isHoveredColorschemeSettings.value == false)
                            revealer.revealChild = showColorScheme.value;
                    }, 2000);
                }
            })
    },
})
