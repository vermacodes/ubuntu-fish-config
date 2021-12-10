#!/bin/bash

rm -rf ubuntu-fish-config
git clone https://github.com/vermacodes/ubuntu-fish-config.git
cd ubuntu-fish-config

if [ ! -d /home/${USER}/.config/fish ]; then
  echo "fish config directory not found; creating now."
  mkdir -p /home/${USER}/.config/fish
else
  echo "fish config directory exists"
fi

cp -R /home/${USER}/ubuntu-fish-config/* /home/${USER}/.config/fish/

#
# Copy stuff from backup.
#
if [ ! -d /home/${USER}/.local/share ]; then
  echo "fish history directory not found; creating now."
  mkdir -p /home/${USER}/.local/share
else
  echo "fish history directory exists"
fi
cp -R /data/jumpusers/${USER}/.local/share/fish/* /home/${USER}/.local/share/fish/

#
# Setup cronjob if it doesnt exist already
#
chmod 755 /home/${USER}/ubuntu-fish-config/history.sh
crontab -l > /home/${USER}/cron_bkp
if ! grep -q "/home/${USER}/ubuntu-fish-config/history.sh" "/home/${USER}/cron_bkp"; then
  echo "cronjob not found; adding now"
  echo "0 * * * * /home/${USER}/ubuntu-fish-config/history.sh > /dev/null 2>&1" >> /home/${USER}/cron_bkp
  crontab /home/${USER}/cron_bkp
else
  echo "cronjob found; skipping"
fi
rm /home/${USER}/cron_bkp
