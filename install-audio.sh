#!/bin/sh -e

# to set volume:
# amixer cset numid=1 -- 100%

echo "Installing audio software"

# alsa-utils already installed, not needed
apt-get -y install mpg321

apt-get -y install omxplayer
