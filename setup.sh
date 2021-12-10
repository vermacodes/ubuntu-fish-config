#!/bin/bash

if [ ! -d /home/av035p/.config/fish ]; then
  echo "fish config directory not found; creating now."
  mkdir -p /home/av035p/.config/fish
else
  echo "fish config directory exists"
fi

cp -R /home/av035p/ubuntu-fish-config/* /home/av035p/.config/fish/

#
# Copy stuff from backup.
#
if [ ! -d /home/av035p/.local/share/fish ]; then
  echo "fish history directory not found; creating now."
  mkdir -p /home/av035p/.local/share/fish
else
  echo "fish history directory exists"
fi
cp -R /data/jumpusers/av035p/.local/share/fish/ /home/av035p/.local/share/fish/

#
# Setup cronjob if it doesnt exist already
#
chmod 755 /home/av035p/ubuntu-fish-config/history.sh
crontab -l > /home/av035p/cron_bkp
if ! grep -q "/home/av035p/ubuntu-fish-config/history.sh" "/home/av035p/cron_bkp"; then
  echo "cronjob not found; adding now"
  echo "0 * * * * /home/av035p/ubuntu-fish-config/history.sh > /dev/null 2>&1" >> /home/av035p/cron_bkp
  crontab /home/av035p/cron_bkp
else
  echo "cronjob found; skipping"
fi
rm /home/av035p/cron_bkp
