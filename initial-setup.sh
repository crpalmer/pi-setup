#!/bin/sh -e

echo "Adding crpalmer"

adduser crpalmer
addgroup crpalmer audio

echo "Deleting the pi user"

deluser pi

echo "Setting up ssh keys"

scp -r crpalmer@compile:.ssh ~
scp -r crpalmer@compile:.ssh ~crpalmer

echo "Configuring crpalmer for git"

sudo crpalmer git config --global user.name "Christopher R. Palmer"
sudo crpalmer git config --global user.email crpalmer@gmail.com

echo "Configuring root for git"

git config --global user.name "Christopher R. Palmer"
git config --global user.email crpalmer@gmail.com

echo "Setting EDIIOR to vi"

echo 'export EDITOR=vi' >> /etc/bash.bashrc
