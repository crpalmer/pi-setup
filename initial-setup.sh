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
scp -r crpalmer@compile:.ssh ~crpalmer

echo "Configuring crpalmer for git"

(
    cd ~crpalmer
    sudo -u crpalmer git config --global user.name "Christopher R. Palmer"
    sudo -u crpalmer git config --global user.email crpalmer@gmail.com
)

echo "Configuring root for git"

git config --global user.name "Christopher R. Palmer"
git config --global user.email crpalmer@gmail.com

echo "Setting EDIIOR to vi"

echo 'export EDITOR=vi' >> /etc/bash.bashrc
