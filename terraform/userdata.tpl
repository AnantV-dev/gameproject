#! /bin/bash
sudo amazon-linux-extras install tomcat8.5 -y
sudo systemctl enable tomcat
sudo systemctl start tomcat
sudo cp /tmp/gaming.war /usr/share/tomcat/webapps/gaming.war