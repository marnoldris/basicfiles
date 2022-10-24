#!/bin/bash

# change shell
echo "Changing shell..."
chsh -s $(which zsh)

# copy in files
echo -e "\nCopying essential files..."
cp -v .zshrc.root ~/.zshrc
cp -v .vimrc ~/.vimrc
#if is_apple
if [[ -e /sys/module/hid_apple ]]; then
    echo -e "\nApple computer detected, adding fnmode service..."
    cp -v fnmode.service /etc/systemd/system/
fi

# enable system services
echo -e "\nEnabling extra system services..."
systemctl enable cronie.service sshd.service reflector.service reflector.timer
#if is_apple
if [[ -e /sys/module/hid_apple ]]; then
    echo -e "\nEnabling fnmode.service..."
    systemctl enable fnmode.service
fi

# start system services
echo -e "\nAttempting to start reflector.timer..."
systemctl start reflector.timer

# make files executable
#echo -e "\nMaking qtile_usersetup.sh and ./kde_usersetup.sh executable..."
#chmod +x ./qtile_usersetup.sh ./kde_usersetup.sh

# tweak /etc/pacman.conf
echo -e "\nTweaking /etc/pacman.conf..."
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf


# finished!
echo -e "\nDone!"
