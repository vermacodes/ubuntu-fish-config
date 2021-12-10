#!/bin/bash

if [ ! -d .config/fish ]; then
  mkdir -p .config/fish
fi

cp -R ./ .config/fish/

#
# Copy stuff from backup.
#
cp -R /data/jumpusers/av035p/.local/share/fish/* /home/av035p/.local/share/fish/

#
# Setup cronjob if it doesnt exist already
#
chmod 755 /home/av035p/ubuntu-fish-config/history.sh
crontab -l > /home/av035p/cron_bkp
echo "0 * * * * /home/av035p/ubuntu-fish-config/history.sh > /dev/null 2>&1" >> /home/av035p/cron_bkp
crontab cron_bkp
rm cron_bkp