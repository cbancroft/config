# Red Flat Awesome WM config
Custom config for [Awesome WM](http://awesome.naquadah.org).

## Description
This config based on the excellent [Redflat](https://github.com/worron/redflat)
awesome configuration by [Worron](https://github.com/worron).  It is modified a
bit to fit my own needs, and is compatible with Awesome 4.0 only.

#### General Feature List
* Full color control, including widget icons;
* True vector scaling for widget icons (gdkpixbuf required);
* New unique panel widgets and some reworked from standart lib;
* A pack of desktop widgets;
* A pack of widgets for applications control (quick launch, application switch, ect);
* Several minor improvements for menu widget;
* Alternative titlebars with several visual schemes;
* Active screen edges;
* Emacs-like key sequences;
* Advanced hotkeys helper;
* Special window control mode which allow use individual hokeys for different layouts;
* New tiling layout to build your placement scheme manually;

## Dependencies
#### Main
* Awesome WM 4.0+

#### Widgets
| widget                 | type          | utility                                     |
| -------------          | ------------- | -------------                               |
| new mail indicator     | panel         | curl/user scripts                           |
| keyboard layout        | panel         | kbdd, dbus-send                             |
| system upgrades        | panel         | apt-get                                     |
| volume control         | panel         | pacmd                                       |
| brightness control     | floating      | xbacklight/unity-settings-daemon, dbus-send |
| mpris2 player          | floating      | dbus-send                                   |
| CPU temperature        | desktop       | lm-sensors                                  |
| HDD temperature        | desktop       | hddtemp, curl                               |
| Nvidia GPU temperature | desktop       | nvidia-smi                                  |
| torrent info           | desktop       | transmission-remote                         |

