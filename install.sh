echo "Compiling and installing program"
cargo install --path .

echo "Adding the notification icon to the xdg list"
xdg-icon-resource install --novendor OV.png --size 200

echo "Installation is completed."
echo "Enjoy!"
