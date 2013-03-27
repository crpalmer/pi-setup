To setup a new install

ssh as pi / raspberry

sudo raspi-config
  * update
  * expand_rootfs
  * change_timezone
  * memory_split (use least video memory)
  * boot_behaviour (no X)

Allow it to reboot

sudo su -
apt-get install git
git clone https://github.com/crpalmer/pi-setup.git setup
cd setup
./initial-setup.sh

edit /etc/sudoers and change pi to crpalmer (last line)

exit and log back in

edit .git/config and change origin to git@github.com:crpalmer/pi-setup
