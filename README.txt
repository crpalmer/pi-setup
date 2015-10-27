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
