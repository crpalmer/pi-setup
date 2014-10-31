To setup a new install, plug in the ethernet cable, boot and then

ssh-keygen -f "/home/crpalmer/.ssh/known_hosts" -R raspberrypi
ssh pi@raspberrypi
 (password: raspberry)

sudo raspi-config
  * Advanced >> Update
  * Advanced >> Hostname
  * Advanced >> Memory Split (use least video memory)
  * Expand filesystem
  * Enable boot to ... (make sure it is booting to console)
  * Internationalisation >> Change_timezone

Allow it to reboot and then ssh pi@<new host name you picked>

sudo su -
apt-get update
apt-get upgrade
rpi-update
shutdown -r now

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

