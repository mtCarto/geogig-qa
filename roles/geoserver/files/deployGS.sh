#!/bin/bash
cd ~/
mv geoserver/web/app/target/geoserver.war /opt/apache-tomcat/webapps/
cd /opt/apache-tomcat/webapps/
unzip geoserver.war