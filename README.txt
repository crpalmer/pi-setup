Make sure you have the rpi-imager installed:

sudo snap install rpi-imager

Run the rpi-imager with the sd card inserted and install the Lite Raspberry Pi
OS to it.  When setting up the install, enter a hostname, username / password,
wifi credentials, enable SSH, etc.

Insert the sdcard and boot up the pi with ethernet attached (if possible)
and then:

If you have reusing a hostname that is already known clear the keys:

ssh-keygen -f "/home/crpalmer/.ssh/known_hosts" -R HOSTNAME

and then ssh to the machine.

sudo raspi-config
  * Advanced Options >> Expand filesystem [probably not needed anymore]
  * Localization Options >> Change Locale to en_US.UTF-8 UTF-8 and use it as default

Don't bother restarting and instead update the software:

sudo su -
apt-get update && apt-get -y upgrade && apt-get -y install git && apt autoremove -y

Restart and login again.

sudo su -
git clone https://github.com/crpalmer/pi-setup.git setup
cd setup
./initial-setup-generic.sh

If you want to add the halloween autorun script run:

./setup-autorun.sh

vi .git/config
  change origin to git@github.com:crpalmer/pi-setup

exit to get back to crpalmer:

git clone git@github.com:crpalmer/pi_lib.git lib
(cd lib && make)

----------------------- Halloween set ----------------------------------

Setup external projects:

git clone https://github.com/crpalmer/tinyalsa.git
cd tinyalsa && mkdir build && cd build && cmake .. && make

git clone --single-branch --branch master git@github.com:crpalmer/halloween-media.git halloween-media.master
git clone --single-branch --branch YEAR git@github.com:crpalmer/halloween-media.git
git clone git@github.com:crpalmer/halloween
(cd halloween/ && make)
(cd halloween/YEAR && make)

----------------------------------------------------------------------------
--                                                                        --
--                         Additional Options                             --
--                                                                        --
----------------------------------------------------------------------------

==== Static IP ====

Change /etc/dhcpcd.conf and update the network device to make static like:

interface eth0
static ip_address=192.168.1.6
static routers=192.168.1.1
static domain_name_servers=192.168.1.1


==== Temperature Sensors on 1wire ======

sudo raspi-config
 * interfacing Options >> 1 Wire Interface >> Yes

and reboot

You should now see devices in /sys/bus/w1/devices that correspond to the device id and also a w1_bus_master1 device.


==== Kiosk Mode ====

sudo apt-get install lxde lightdm xinit
sudo apt-get install chromium-browser x11-xserver-utils

Set the boot mode to be to log pi into the desktop via raspi-config:
  * Boot Options >> Desktop / CLI >> Desktop Autologin as crpalmer

===== Ruby on Rails ====

Install rvm and other packages:

  sudo apt-get install -y libxml2-dev libxslt-dev
  sudo apt-get install -y nodejs
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -L get.rvm.io | bash -s stable --rails
  . ~/.rvm/scripts/rvm
  rvm use ruby
  gem install rails
  bundle install
  gem install execjs

Load rvm on login by adding this to .bashrc:

  source ~/.rvm/scripts/rvm

To update to the latest ruby in your branch do

  rvm install ruby
  rvm use ruby
  rvm upgrade <old-version> ruby

===== HDMI on keezer ====

Set this in /boot/config.txt:

hdmi_group=1
hdmi_mode=4

==== Keezer Setup after Kiosk Mode and Ruby on Rails ===

git clone git@github.com:crpalmer/keezer.git
(cd keezer/server ; make install)

Add a startup script to ".config/lxsession/LXDE/autostart":
@/opt/keezer/lxde-autostart.sh

Add refresh cron job
Add starting ruby server
Add starting temp controller

