#!/bin/sh -e

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

cat > /root/autorun.sh <<EOF
#!/bin/bash
sleep 120
EOF

chmod +x /root/autorun-wrapper.sh /root/autorun.sh
