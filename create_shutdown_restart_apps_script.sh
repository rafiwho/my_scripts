#!/bin/bash

# Create a desktop entry file for shutdown
cat <<EOF > /tmp/shutdown.desktop
[Desktop Entry]
Version=1.0
Name=Shutdown
Comment=Shutdown the computer
Exec=systemctl poweroff
Icon=system-shutdown
Terminal=false
Type=Application
EOF

# Create a desktop entry file for restart
cat <<EOF > /tmp/restart.desktop
[Desktop Entry]
Version=1.0
Name=Restart
Comment=Restart the computer
Exec=systemctl reboot
Icon=system-restart
Terminal=false
Type=Application
EOF

# Move the shortcuts to the applications directory
sudo mv /tmp/shutdown.desktop /usr/share/applications/shutdown.desktop
sudo mv /tmp/restart.desktop /usr/share/applications/restart.desktop

echo "Shutdown and Restart application shortcuts created."
