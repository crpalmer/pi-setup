#!/bin/sh -e

echo "Adding crpalmer"

adduser crpalmer
for group in `groups pi | sed 's/.* : pi //'`
do
    addgroup crpalmer $group
done

echo "Disabling the pi user"

passwd -l pi

echo "Setting up ssh keys"

scp -r crpalmer@compile:.ssh ~

rm -f ~/.ssh/known_hosts
cp -r ~/.ssh ~crpalmer/
chown -R crpalmer ~crpalmer/.ssh

echo "Configuring crpalmer for git"

(
    cd ~crpalmer
    sudo -u crpalmer git config --global user.name "Christopher R. Palmer"
    sudo -u crpalmer git config --global user.email crpalmer@gmail.com
    sudo -u crpalmer git config --global color.ui true
)

echo "Configuring root for git"

git config --global user.name "Christopher R. Palmer"
git config --global user.email crpalmer@gmail.com

echo "Setting EDIIOR to vi"

echo 'export EDITOR=vi' >> /etc/bash.bashrc

echo "Installing packages"

apt-get install libusb-dev mpg321
