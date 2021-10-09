Make sure you have the rpi-imager installed:

sudo snap install rpi-imager

Run the rpi-imager with the sd card inserted and install the Lite Raspberry Pi OS to it.  After it
is installed enable SSH:

mkdir -p /tmp/mnt
sudo mount /dev/sdi1 /tmp/mnt
sudo touch /tmp/mnt/ssh
sudo umount /dev/sdi1

Insert the sdcard and boot up the pi with ethernet attached and then:

[NOT WORKING - the create wpa_supplicant.conf was missing the network section] If you want to manually configure wifi instead of attaching an ethernet cable them add this file
to /boot/wpa_supplicant.conf:

--

ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
country=US
update_config=1

network={
 ssid="palmer"
 psk="password"
}

--

before the first boot.  Either way boot it and on the local computer run:

ssh-keygen -f "/home/crpalmer/.ssh/known_hosts" -R raspberrypi
ssh pi@raspberrypi
 (password: raspberry)


sudo raspi-config
  * Advanced Options >> Expand filesystem
  * Localization Options >> Change Locale to en_US.UTF-8 UTF-8 and use it as default
  * Locatization Options >> Change Timezone
  * System >> Wifi set the AP name/password
  * System >> Hostname
  * Interfacing Options >> I2C >> Enable

Reboot, remove ethernet and login again using the new hostname:

sudo shutdown -r now
ssh pi@<new hostname>

Update the software:

sudo su -
apt-get update && apt-get -y upgrade && apt-get -y install git && apt autoremove -y
shutdown -r now

Run the basic setup:

sudo su -
git clone https://github.com/crpalmer/pi-setup.git setup
cd setup

and then run which every one makes more sense:

./initial-setup-halloween.sh
./initial-setup-generic.sh

vi .git/config
  change origin to git@github.com:crpalmer/pi-setup

exit, exit and login as crpalmer

git clone git@github.com:crpalmer/pi_lib.git lib
(cd lib && make)

----------------------- Halloween set ----------------------------------

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

