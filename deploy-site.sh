# *****************************************************************************************
# source: https://klau.si/dev
# how to use it $ sudo deploy-site.sh <sitename>
# *****************************************************************************************
#!/bin/bash

if [[ $# -lt 1 || $1 == "--help" || $1 == "-h" ]]
then
  echo "Usage:"
  echo "  sudo `basename $0` SITENAME"
  echo "Examples:"
  echo "  sudo `basename $0` drupal-8"
  exit
fi

WORKDIR="/home/klausi/workspace"
APACHEDIR="/etc/apache2/sites-available"
HOSTSFILE="/etc/hosts"

echo "<VirtualHost *:80>
	ServerAlias $1.localhost
	DocumentRoot $WORKDIR/$1
	<Directory \"$WORKDIR/$1\">
		Options FollowSymLinks
		AllowOverride All
		Require all granted
        </Directory>
</VirtualHost>" > $APACHEDIR/$1.conf
a2ensite $1
service apache2 restart
grep -q "127.0.0.1  $1.localhost" $HOSTSFILE
if [ $? -ne 0 ]; then
  echo "127.0.0.1  $1.localhost" >> $HOSTSFILE
fi
