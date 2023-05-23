# OmegaV-dekstop-notification-daemon
This is a program that runs in the background and sends a desktop notification whenever the status of the door changes.

## Why does this exist
During the exam period I found myself always missing when OV was open for a bit, it was always open five minutes ago.
That is how this program was born. By getting a notification every time OV opens, or closes I am able to rush to OV before it closes again.

This is just a niche problem, only really relevant to the mornings during the exam period. But I figured that I wasn't the only one who has this issue, and as such decided to share this piece of software I wrote for myself.

## Installation
Run the `install.sh` script.

This script takes care of the entire installation process given you are on Debian, or a Debian based distro.
If you are not, it will give you a dependency warning, but take care of the rest of the installtion.

### Platform supprot
| Platform | Support | Notes |
| :------- | :------ | :---- |
| Linux    | Full    |       |
| Windows  | Partial | It compiles and runs for windows, but there are no images. There is no installer either. |
| Mac OS   | Partial | Theoretically the state should be the same as for Windows, but I have yet to test it. |
