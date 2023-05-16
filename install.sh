# Create a variable to see if the script ended with an error
SCRIPT_ERR=0

# Check if the user is running a debian derivative
if ls /usr/bin/apt >/dev/null 2>&1; then
    echo "Debian based system detected, automatically installing dependencies"

    # Check if they have the depenency installed
    if dpkg -s "libssl-dev" >/dev/null 2>&1; then
        echo "All dependecies are installed!"
    else
        # If not, install it
        echo "dependency \"libssl-dev\" is not installed."
        echo "installing..."
        sudo apt install libssl-dev -y
    fi
else
    # Non debian based distros have to manually install
    echo "-------------------------------------------------------------------------------------------------------"
    echo "You may need to install an ssl development package to compile this program."
    echo "On debian and ubuntu it is called \`libssl-dev\`. Please install the equivalent for your distribution."
    echo "-------------------------------------------------------------------------------------------------------"
fi

# Install the program
if ! cargo install --path .; then
    # If the install failed warn the user
    echo "\033[0;31Failed to install programm.\033[0m]"
    echo "Are you missing the libssl-dev dependency?"
    SCRIPT_ERR+=1
fi

# Check if OV icon already exists
if ls ~/.local/share/icons/hicolor/200x200/apps/OV.png >/dev/null 2>&1; then
    echo "OV icon is already installed."
else
    echo "Adding the OV icon to the xdg list"
    if ! xdg-icon-resource install --novendor OV.png --size 200; then
        echo "\033[0;31Failed to add OV icon\033[0m"
        SCRIPT_ERR+=1
    fi
fi

echo "Install completed with $SCRIPT_ERR errors."
echo "Enjoy!"