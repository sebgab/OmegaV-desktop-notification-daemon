#!/usr/bin/bash

# Create a variable to see if the script ended with an error
SCRIPT_ERR=0

#TODO: Check if rust is installed, and handle that case.

#
# Dependency installation
#

# Check if the user is running a debian derivative
if ls /usr/bin/apt >/dev/null 2>&1; then
    echo "Debian based system detected, automatically installing dependencies."

    # Check if they have the depenency installed
    if dpkg -s "libssl-dev" >/dev/null 2>&1; then
        echo -e "\e[32mAll dependecies are installed!\e[0m"
    else
        # If not, install it
        echo "dependency \"libssl-dev\" is not installed."
        echo "installing..."
        sudo apt install libssl-dev -y
    fi
else
    # Non debian based distros have to manually install
    echo -e "\e[1;33m-------------------------------------------------------------------------------------------------------\e[0m"
    echo -e "\e[1;33mYou may need to install an ssl development package to compile this program.\e[0m"
    echo -e "\e[1;33mOn Debian and Ubuntu it is called \`libssl-dev\`. Please install the equivalent for your distribution.\e[0m"
    echo -e "\e[1;33m-------------------------------------------------------------------------------------------------------\e[0m"
fi

#
# Program installation
#

# Install the program
if ! cargo install --path .; then
    # If the install failed warn the user
    echo "\033[0;31Failed to install program.\033[0m]"
    echo "Are you missing the libssl-dev dependency?"
    SCRIPT_ERR+=1
fi

#
# Icon installtion
#

# Check if OV icon already exists
if ls ~/.local/share/icons/hicolor/200x200/apps/OV.png >/dev/null 2>&1; then
    echo -e "\e[32mOV icon is already installed.\e[0m"
else
    echo "Adding the OV icon to the xdg list"
    if ! xdg-icon-resource install --novendor OV.png --size 200; then
        echo -e "\e[31mFailed to add OV icon\e[0m"
        SCRIPT_ERR+=1
    fi
fi

#
# Desktop file installation
#

# Take backup of default desktop file
cp omegav-daemon.desktop omegav-daemon.desktop.default
# Replace the username with the proper user
username=$(whoami)
sed -i "s/\$USER/$username/g" omegav-daemon.desktop

# Add the program to the list of installed programs
xdg-desktop-menu install omegav-daemon.desktop
# Add it to autostart
ln -s ~/.local/share/applications/omegav-daemon.desktop ~/.config/autostart

# Inform the user of the result of the installation.
echo "Install completed with $SCRIPT_ERR errors."
echo "Enjoy!"
