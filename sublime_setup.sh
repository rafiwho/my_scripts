#!/bin/bash

# Update package list
sudo apt update

# Install required dependencies
sudo apt install apt-transport-https ca-certificates curl g++ xclip -y

# Add the Sublime Text GPG key
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

# Add the Sublime Text stable repository
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Add the Sublime Merge stable repository
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-merge.list

# Update apt sources
sudo apt update

# Install Sublime Text
if ! command -v subl &> /dev/null; then
    echo "Sublime Text not found, installing..."
    sudo apt install sublime-text -y
else
    echo "Sublime Text is already installed."
fi

# Install Sublime Merge
if ! command -v sublime-merge &> /dev/null; then
    echo "Sublime Merge not found, installing..."
    sudo apt install sublime-merge -y
else
    echo "Sublime Merge is already installed."
fi

# Navigate to the directory and precompile stdc++.h
cd /usr/include/x86_64-linux-gnu/c++/13/bits/    
sudo g++ -std=c++20 stdc++.h

# Set variables for the first repo
repo1_url="https://github.com/rafiwho/User/archive/refs/heads/main.zip"
download_path1="/home/rafiwho/Downloads"

# Check for the correct Sublime Text Packages directory
if [ -d "$HOME/.config/sublime-text-3/Packages/User" ]; then
    destination_path1="$HOME/.config/sublime-text-3/Packages/User"
elif [ -d "$HOME/.config/sublime-text/Packages/User" ]; then
    destination_path1="$HOME/.config/sublime-text/Packages/User"
else
    echo "Sublime Text Packages/User directory not found. Creating it..."
    mkdir -p "$HOME/.config/sublime-text-3/Packages/User" || mkdir -p "$HOME/.config/sublime-text/Packages/User"
    destination_path1="$HOME/.config/sublime-text-3/Packages/User"
fi

# Set variables for the second repo
repo2_url="https://github.com/rafiwho/codes/archive/refs/heads/main.zip"
download_path2="/home/rafiwho/Downloads"
destination_path2="$HOME/codes"

# Check if destination directory for the second repo exists, if not create it
if [ ! -d "$destination_path2" ]; then
    echo "Creating directory $destination_path2"
    mkdir -p "$destination_path2"
fi

# Download the first repo as a zip file
wget -O "$download_path1/User.zip" "$repo1_url"

# Unzip the first repo
unzip "$download_path1/User.zip" -d "$download_path1"

# If the destination folder exists, delete it
if [ -d "$destination_path1" ]; then
    rm -rf "$destination_path1"
fi

# Move the unzipped contents to the destination
mv "$download_path1/User-main" "$destination_path1"

# Remove the first zip file
rm "$download_path1/User.zip"

# Download the second repo as a zip file
wget -O "$download_path2/codes.zip" "$repo2_url"

# Unzip the second repo
unzip "$download_path2/codes.zip" -d "$download_path2"

# If the destination folder exists, delete it
if [ -d "$destination_path2" ]; then
    rm -rf "$destination_path2"
fi

# Move the unzipped contents to the destination
mv "$download_path2/codes-main" "$destination_path2"

# Remove the second zip file
rm "$download_path2/codes.zip"

# Merge the contents of both directories
echo "Merging contents of User and codes directories into one directory..."
cp -r "$destination_path1"/* "$destination_path2"

# Now the contents from "User" are merged into the "codes" directory
echo "Merge complete."

# Generate SSH key if it doesn't already exist
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -C "uodoyhossanrafi420@gmail.com" -f "$HOME/.ssh/id_rsa" -N ""
else
    echo "SSH key already exists."
fi

# Add SSH key to the SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# Copy the SSH public key to clipboard
echo "Copying SSH public key to clipboard..."
cat ~/.ssh/id_rsa.pub | xclip -selection clipboard

echo "SSH key generated and copied to clipboard."
