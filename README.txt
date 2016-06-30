To setup a new install, flash the latest img and setup the initial
wifi config something like:

sudo dd if=/tmp/2016-05-27-raspbian-jessie-lite.img of=/dev/sdc
sudo cp wpa_supplicant.conf /media/crpalmer/202638e1-4ce4-45df-9a00-ad725c2537bb/etc/wpa_supplicant/

Insert the sdcard and boot up the pi and then:

ssh-keygen -f "/home/crpalmer/.ssh/known_hosts" -R raspberrypi
ssh pi@raspberrypi
 (password: raspberry)

sudo raspi-config
  * Expand filesystem
  * Internationalisation >> Change_timezone
  * Advanced >> Hostname
  * Advanced >> Memory Split (use least video memory)
  * Advanced >> Update

Reboot and login again using the new hostname:

sudo shutdown -r now
ssh pi@<new hostname>

Update the software:

sudo su -
apt-get update
apt-get upgrade
shutdown -r now

sudo su -
apt-get install git
git clone https://github.com/crpalmer/pi-setup.git setup
cd setup
./initial-setup.sh

edit /etc/sudoers and change pi to crpalmer (last line)
edit .git/config and change origin to git@github.com:crpalmer/pi-setup

exit, exit and login as crpalmer

git clone git@github.com:crpalmer/pi_lib.git lib
(cd lib && make)
git clone git@github.com:crpalmer/halloween
(cd halloween/ && make)
(cd halloween/YEAR && make)
git clone --single-branch --branch YEAR git@github.com:crpalmer/halloween-media.git 


----------------------------------------------------------------------------
--                                                                        --
--                         Additional Options                             --
--                                                                        --
----------------------------------------------------------------------------

==== Static IP ====

Change /etc/network/interfaces and update the wlan section to

iface wlan0 inet static
        wpa-ssid "palmer"
        wpa-psk  "chrispalmer"
        address 192.168.1.**ip**
        netmask 255.255.255.0
        gateway 192.168.1.1
	dns-nameservers 192.168.1.1


==== Temperature Sensors on 1wire ======

sudo mkdir /mnt/1wire
sudo apt-get install owserver owfs

You need to add /etc/init.d/owfs which can be found in my github in
keezer/server.

If using kiosk mode then you will need to start the services in /etc/rc.local

start owserver
start owfs


==== Kiosk Mode ====

Set the boot mode to be to log pi into the desktop via raspi-config.

sudo apt-get install chromium-browser x11-xserver-utils

Add a startup script to "/etc/xdg/lxsession/LXDE/autostart".  For example adding:
@/opt/keezer/lxde-autostart.sh

Look at keezer.git for an example of what to put in it.


===== Ruby on Rails ====

Install rvm and other packages:

  sudo apt-get install -y libxml2-dev libxslt-dev
  sudo apt-get install -y nodejs
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -L get.rvm.io | bash -s stable --rails
  . ~/.rvm/scripts/rvm
  gem install execjs

Load rvm on login by adding this to .bashrc:

  source ~/.rvm/scripts/rvm
