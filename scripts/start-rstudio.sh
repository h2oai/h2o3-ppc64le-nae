#!/bin/bash

# Change Nginx Redirect
sudo sed -e 's/8888/8787/' -i /etc/nginx/sites-enabled/default
sudo sed -e 's/8888/8787/' -i /etc/nginx/sites-enabled/notebook-site

sudo rm -f /etc/NAE/url.txt
sudo echo "http://%PUBLICADDR%:8787/" > /etc/NAE/url.txt

# Start SSH
sudo service ssh restart
# Start RStudio
sudo service nginx restart

sudo rstudio-server restart
