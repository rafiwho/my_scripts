#!/bin/bash

# Install g++
sudo apt update
sudo apt install -y g++

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
    echo "Sublime Text Packages/User directory not found."
    exit 1
fi

# Set variables for the second repo
repo2_url="https://github.com/rafiwho/codes/archive/refs/heads/main.zip"
download_path2="/home/rafiwho/Downloads"
destination_path2="$HOME/codes"

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
