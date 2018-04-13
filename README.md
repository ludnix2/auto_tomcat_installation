# auto_tomcat_installation
Automatically install and configure Java and Tomcat application server on centos

Hey you need to edit this lines if you need some specific version.

For tomcat installation you need to put tar.gz archive URL for now as script can't auto detect last version yet.
But I have it in future plans to add auto detect function. If anyone can add auto detect support to this script he is already welcomed.

You can browse ionfish.org (or any other you like) mirrors website to find your preffered version http://apache.mirrors.ionfish.org/tomcat/

Below is lines from script that you need to edit 

# Tomcat variables

SERVICE_NAME="/etc/systemd/system/tomcat.service"
TOMCAT_URL=http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.30/bin/apache-tomcat-8.5.30.tar.gz
TOMCAT_DIR=/opt/tomcat

For Java it can do autodetect you need to told script which version you want to install jdk/jre , which version.

# Java variables

JAVA_TYPE="jdk"
JAVA_VERSION="8"
