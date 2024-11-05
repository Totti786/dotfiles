import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Brightness from '../../../services/brightness.js';
import Indicator from '../../../services/indicator.js';
import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
const { exec, execAsync } = Utils;

const WindowTitle = async () => {
    try {
        const Hyprland = (await import('resource:///com/github/Aylur/ags/service/hyprland.js')).default;
        return Widget.Scrollable({
            hexpand: true, vexpand: true,
            hscroll: 'automatic', vscroll: 'never',
            child: Widget.Box({
                vertical: true,
                children: [
                    Widget.Label({
                        xalign: 0,
                        truncate: 'end',
                        maxWidthChars: 1, // Doesn't matter, just needs to be non negative
                        className: 'txt-smaller bar-wintitle-topdesc txt',
                        setup: (self) => self.hook(Hyprland.active.client, label => { // Hyprland.active.client
                            label.label = Hyprland.active.client.class.length === 0 ? 'Desktop' : Hyprland.active.client.class;
                        }),
                    }),
                    Widget.Label({
                        xalign: 0,
                        truncate: 'end',
                        maxWidthChars: 1, // Doesn't matter, just needs to be non negative
                        className: 'txt-smallie bar-wintitle-txt',
                        setup: (self) => self.hook(Hyprland.active.client, label => { // Hyprland.active.client
                            label.label = Hyprland.active.client.title.length === 0 ? `Workspace ${Hyprland.active.workspace.id}` : Hyprland.active.client.title;
                        }),
                    })
                ]
            })
        });
    } catch {
        return null;
    }
}

// Define the throttle function outside the main export function
let lastScrollTime = 0;
const throttleDelay = 50; // Adjust delay as needed

function throttleScroll(action) {
    const now = Date.now();
    if (now - lastScrollTime >= throttleDelay) {
        action();
        lastScrollTime = now;
    }
}

export default async (monitor = 0) => {
    const optionalWindowTitleInstance = await WindowTitle();
    return Widget.EventBox({
        onScrollUp: () => {
            throttleScroll(() => {
                Utils.execAsync('brightnessctl set 5%+').catch(print);
            });
        },
        onScrollDown: () => {
            throttleScroll(() => {
                Utils.execAsync('brightnessctl set 5%-').catch(print);
            });
        },	
        onPrimaryClick: () => {
            App.toggleWindow('sideleft');
        },
        onSecondaryClick: () => {
            Utils.execAsync('clight.sh --capture').catch(print);
        },
        onMiddleClick: () => {
            Utils.execAsync('clight.sh --toggle-pause').catch(print);
        },
        child: Widget.Box({
            homogeneous: false,
            children: [
                Widget.Box({ className: 'bar-corner-spacing' }),
                Widget.Overlay({
                    overlays: [
                        Widget.Box({ hexpand: true }),
                        Widget.Box({
                            className: 'bar-sidemodule', hexpand: true,
                            children: [Widget.Box({
                                vertical: true,
                                className: 'bar-space-button',
                                children: [
                                    optionalWindowTitleInstance,
                                ]
                            })]
                        }),
                    ]
                })
            ]
        })
    });
}
