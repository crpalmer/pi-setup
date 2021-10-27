#!/bin/sh -e

./initial-setup-generic.sh

echo "Installing packages"

apt-get install -y libusb-dev mpg322 ffmpeg i2c-tools

echo "Setting up autorun"

cat > /etc/rc.local <<EOF
#!/bin/bash
/root/autorun-wrapper.sh > /root/autorun.log 2>&1 &
exit 0
EOF

cat > /root/autorun-wrapper.sh <<EOF
#!/bin/bash
if [ -x /root/autorun.sh ]
then
   while true
   do
      /root/autorun.sh
      sleep 1
   done
else
   echo "Autorun is disabled"
fi
EOF

chmod +x /root/autorun-wrapper.sh
