To setup a new install, plug in the ethernet cable, boot and then

ssh as pi / raspberry

sudo raspi-config
  * Advanced >> Update
  * Advanced >> Hostname
  * Advanced >> Memory Split (use least video memory)
  * Advanced >> Boot make sure it books to console
  * Expand filesystem
  * Internationalisation >> Change_timezone

Allow it to reboot

sudo su -
apt-get install git
git clone https://github.com/crpalmer/pi-setup.git setup
cd setup
./initial-setup.sh

edit /etc/sudoers and change pi to crpalmer (last line)
edit .git/config and change origin to git@github.com:crpalmer/pi-setup
edit /etc/modprobe.d/raspi-blacklist.conf and comment out spi-bcm2708

exit, exit and login as crpalmer

git clone git@github.com:crpalmer/pi_lib.git lib
(cd lib && make)
git clone git@github.com:crpalmer/halloween
(cd halloween/2014 && make)

unplug the ethernet cable and reboot

