#!/bin/bash
################################################################################
##
## Title: Apache Tomcat Installer
##
## Date: 12/04/2018
## Author: Ludwig Markosyan
## Version: 0.2
##
## Changelog: 0.1 - Initial Release
## Changelog: 0.2 - Bug fixes
##
## Usage: ./install_tomcat.sh
##
################################################################################

# Tomcat variables

SERVICE_NAME="/etc/systemd/system/tomcat.service"
TOMCAT_URL=http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.30/bin/apache-tomcat-8.5.30.tar.gz
TOMCAT_DIR=/opt/tomcat

# Java variables

JAVA_TYPE="jdk"
JAVA_VERSION="8"
EXT="rpm"


################## Please do not manually edit below lines #####################################

# Installing dependencies
if [ "$(rpm -qa | grep wget)" = "" ] ; then
echo -e "\n\e[32mInstalling dependencies\e[0m"
while true;
do echo -n .;sleep 1;done &
yum -y install wget > /dev/null 2>&1
kill $!; trap 'kill $!' SIGTERM;
echo
fi
# Check if Java installed
if java -version 2>&1 >/dev/null | grep -q "java version";
then
echo "Java is successfully installed!"
java -version
else
read -p "Java is not installed, Do you want to install it before installing tomcat? [Y/n]" -n 1 -r;
if [[ $REPLY =~ ^[Yy]$ ]];
then

# Run below script to install Java

# set default if suggested
if [[ -n "$1" ]]; then
  if [[ "$1" == "7" ]]; then
   JAVA_VERSION="7"
  fi
fi

# set download extension
if [[ -n "$2" ]]; then
  if [[ "$2" == "tar" ]]; then
    EXT="tar.gz"
  fi
fi

# set base download location
URL="http://www.oracle.com"
DOWNLOAD_URL1="${URL}/technetwork/java/javase/downloads/index.html"
DOWNLOAD_URL2=$(curl -s $DOWNLOAD_URL1 | egrep -o "\/technetwork\/java/\javase\/downloads\/${JAVA_TYPE}${JAVA_VERSION}-downloads-.*\.html" | head -1)

# check to make sure we got to oracle
if [[ -z "$DOWNLOAD_URL2" ]]; then
  echo "Could not to oracle - $DOWNLOAD_URL1"
  exit 1
fi

# set download url
DOWNLOAD_URL3="$(echo ${URL}${DOWNLOAD_URL2}|awk -F\" {'print $1'})"
DOWNLOAD_URL4=$(curl -s "$DOWNLOAD_URL3" | egrep -o "http\:\/\/download.oracle\.com\/otn-pub\/java\/jdk\/[7-8]u[0-9]+\-(.*)+\/${JAVA_TYPE}-[7-8]u[0-9]+(.*)linux-x64.${EXT}"|tail -n1)

# check to make sure url exists
if [[ -z "$DOWNLOAD_URL4" ]]; then
  echo "Could not get ${JAVA_TYPE} download url - $DOWNLOAD_URL4"
  exit 1
fi
# set download file name
JAVA_INSTALL=$(basename $DOWNLOAD_URL4)

if [[ "$EXT" == "rpm" ]]; then

        # download java
        echo -e "\n\e[32mDownloading\e[0m: $DOWNLOAD_URL4"
        while true;
        do echo -n .;sleep 1;done &
        cd /tmp; wget -q --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" $DOWNLOAD_URL4 -O $JAVA_INSTALL > /dev/null 2>&1
        kill $!; trap 'kill $!' SIGTERM;
        # install rpm
        echo -e "\n\e[32mInstalling\e[0m: $JAVA_INSTALL\r"
        while true;
        do echo -n .;sleep 1;done &
        rpm -Uvh /tmp/$JAVA_INSTALL > /dev/null 2>&1
        kill $!; trap 'kill $!' SIGTERM;
        echo -e "\n\e[32mInstall\e[0m Complete\n"
        # get dirname
        JAVA_DIR=$(ls -tr /usr/java/|grep ${JAVA_TYPE}|head -n 1)
        # set temp env var
        export JAVA_HOME=/usr/java/${JAVA_DIR}
        # set perm env var
        echo "export JAVA_HOME=/usr/java/${JAVA_DIR}" >> /etc/environment
        # set if jdk is used
        if [[ "$JAVA_TYPE" = "jdk" ]]; then
                # set temp env var
                export JRE_HOME=/usr/java/${JAVA_DIR}/jre
                # set perm env var
                echo "export JRE_HOME=/usr/java/${JAVA_DIR}/${JAVA_TYPE}" >> /etc/environment
        fi
        # make sure java installed
        ls /usr/java/${JAVA_DIR} > /dev/null 2>&1
        if [[ "$?" != 0  ]]; then
                echo -e "\n\e[31mError\e[0m: Java does not seem to be installed correctly,\nPlease try again or email admin: ${ADMIN_EMAIL}\n"
                exit 1
        fi

elif [[ "$EXT" == "tar" || "$EXT" == "tar.gz" ]]; then

        # download java
        echo -e "\n\e[32mDownloading\e[0m: $DOWNLOAD_URL4"
        while true;
        do echo -n .;sleep 1;done &
        cd /opt; wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" $DOWNLOAD_URL4  -O $JAVA_INSTALL > /dev/null 2>&1
        kill $!; trap 'kill $!' SIGTERM;
        # extract the tar
        echo -e "\n\e[32mExtracting\e[0m: $JAVA_INSTALL\r"
        while true;
        do echo -n .;sleep 1;done &
        tar xzf $JAVA_INSTALL > /dev/null 2>&1
        kill $!; trap 'kill $!' SIGTERM;
        echo -e "\n\e[32mInstall\e[0m Complete\n"
        # get dirname
        JAVA_DIR=$(ls -tr /opt/|grep ${JAVA_TYPE}|head -n 1)
        # set default java
        alternatives --install /usr/bin/java java /opt/${JAVA_DIR}/bin/java 1
        alternatives --install /usr/bin/javac javac /opt/${JAVA_DIR}/bin/javac 1
        alternatives --install /usr/bin/jar jar /opt/${JAVA_DIR}/bin/jar 1
        # set temp env vars
        export JAVA_HOME=/opt/${JAVA_DIR}
        export PATH=$PATH:/opt/${JAVA_DIR}/bin:/opt/${JAVA_DIR}/${JAVA_TYPE}/bin
        # set perm env vars
        echo "export JAVA_HOME=/opt/${JAVA_DIR}" >> /etc/environment
        echo "export PATH=$PATH:/opt/${JAVA_DIR}/bin:/opt/${JAVA_DIR}/${JAVA_TYPE}/bin" >> /etc/environment
        # set if jdk is used
        if [[ "$JAVA_TYPE" = "jdk" ]]; then
                # set temp env var
                export JRE_HOME=/opt/${JAVA_DIR}/${JAVA_TYPE}
                # set perm env var
                echo "export JRE_HOME=/opt/${JAVA_DIR}/${JAVA_TYPE}" >> /etc/environment
        fi
        # make sure java installed
        ls /opt/${JAVA_DIR} > /dev/null 2>&1
        if [[ "$?" != 0  ]]; then
                echo -e "\n\e[31mError\e[0m: Java does not seem to be installed correctly,\nPlease try again or email admin: ${ADMIN_EMAIL}\n"
                exit 1
        fi
fi
# end script

else : ;
fi
fi


# First, create a new tomcat group:
groupadd tomcat > /dev/null 2>&1
        if [[ "$?" != 0  ]]; then
                echo -e "\n\e[31mError\e[0m: Group \e[32mtomcat\e[0m already exists, exiting ..."
	exit 1
            fi
# Then create a new tomcat user.
useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

# Create tomcat directory
if [ -d "$TOMCAT_DIR" ]; then
echo -e "\n\e[31mError\e[0m: Folder \e[32m$TOMCAT_DIR\e[0m already exists existing ..."
        exit 1
            fi
if [ -f "$SERVICE_NAME" ]; then
echo -e "\n\e[93mWarning\e[0m: Systemd service\e[32m $SERVICE_NAME\e[0m already exists deleting ..."
            fi

mkdir /opt/tomcat

# On this tutorial we will use 8.5.30 as it is last version on time we are writing this script
echo -e "\n\e[32mDownloading\e[0m: $TOMCAT_URL"
while true;
do echo -n .;sleep 1;done &
cd /tmp; wget -q --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" $TOMCAT_URL > /dev/null 2>&1
kill $!; trap 'kill $!' SIGTERM;

# Unpacking downloaded tar archive
tar xvf /tmp/apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1

# Give the tomcat group ownership over the entire installation directory
#echo -e "\n\e[32mGiving the tomcat group ownership over the entire installation directory\e[0m"
chgrp -R tomcat $TOMCAT_DIR

# Next, give the tomcat group read access to the conf directory and all of its contents, and execute access to the directory itself
#echo -e "\n\e[32mGiving the tomcat group read access to the conf directory and all of its contents, and execute access to the directory itself\e[0m"
chmod -R g+r $TOMCAT_DIR/conf
chmod g+x $TOMCAT_DIR/conf

# Then make the tomcat user the owner of the webapps, work, temp, and logs directories
#echo -e "\n\e[32mMake the tomcat user the owner of the webapps, work, temp, and logs directories\e[0m"
chown -R tomcat $TOMCAT_DIR/webapps/ $TOMCAT_DIR/work/ $TOMCAT_DIR/temp/ $TOMCAT_DIR/logs/

# Lets create and open the unit file by running this command:
#echo -e "\n\e[32mMaking tomcat systemd service\e[0m"
/bin/cat <<EOM >$SERVICE_NAME
# Systemd unit file for tomcat
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target

[Service]
Type=forking

Environment=JAVA_HOME=$JAVA_HOME
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/bin/kill -15 $MAINPID

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOM

# Now reload Systemd to load the Tomcat unit file
systemctl daemon-reload

# Now can enable it to autostart and start the Tomcat service with this systemctl command
echo -e "\n\e[32mEnabling and starting tomcat service\e[0m"
systemctl enable tomcat && systemctl start tomcat