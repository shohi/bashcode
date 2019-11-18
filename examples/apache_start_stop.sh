#!/usr/bin/env bash -x

# shutdown apache2 http server
sudo service lightdm start
sudo /etc/init.d/apache2 stop
