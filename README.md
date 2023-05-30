# OmegaV-desktop-notification-daemon
This is a program that runs in the background and sends a desktop notification whenever the status of the door changes.

![Image of the plugin sending a notification that the door is open](omegav-daemon-example.gif)

## Why does this exist
During the exam period I found myself always missing when OV was open for a bit, it was always open five minutes ago.
That is how this program was born. By getting a notification every time OV opens, or closes I am able to rush to OV before it closes again.

This is just a niche problem, only really relevant to the mornings during the exam period. But I figured that I wasn't the only one who has this issue, and as such decided to share this piece of software I wrote for myself.

## Platform support
| Platform | Support | Notes |
| :------- | :------ | :---- |
| Linux    | Full    |       |
| Windows  | Partial | It compiles and runs on windows. There is an installer, testing is limited. |
| Mac OS   | Partial | Theoretically it should work on Mac OS as well, but I have not tested it. |

## Installation
### Linux
Linux is the main supported platform, and the only platform with an installer.

The preffered method of installation is to clone the repository and run the `install.sh` script.  
```bash
git clone https://github.com/sebgab/OmegaV-desktop-notification-daemon.git
cd OmegaV-desktop-notification-daemon/
./install.sh
```

This script takes care of the entire installation process given you are on Debian, or a Debian based distro.
If you are not, it will give you a dependency warning, but take care of the rest of the installtion.

In the future I might compile some AppImages and add them in the releases section.

### Windows
Windows currently only has partial support. This means that I will fix windows bugs and provide Windows binaries. However, as I don't run windows much the testing on windows is severely limited.
I do compile windows binaries, and they can be found under the releases tab.

There is no auto-updater, so if you have bugs please update to the newest version, if the bug is still there, please create a git issue.


