# auto_tomcat_installation
Automatically install and configure Java and Tomcat application server on centos

You need to edit this lines if you need some specific version, by default it will install apache tomcat 8.5.30 and Java 8 JDK with last update.

For tomcat installation you need to put tar.gz archive URL for now as script can't auto detect last version yet.
But I have it in future plans to add auto detect function. If anyone can add auto detect support to this script he is already welcomed.

You can browse ionfish.org (or any other you like) mirrors website to find your preffered version http://apache.mirrors.ionfish.org/tomcat/

Below is lines from script that you need to edit 

# Tomcat variables

SERVICE_NAME="/etc/systemd/system/tomcat.service" <br>
TOMCAT_URL=http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.30/bin/apache-tomcat-8.5.30.tar.gz <br>
TOMCAT_DIR=/opt/tomcat <br>

For Java it can do autodetect you need to told script which version you want to install jdk/jre , which version.

# Java variables

JAVA_TYPE="jdk" <br>
JAVA_VERSION="8"


# Configure Tomcat Web Management Interface

In order to use the manager webapp that comes with Tomcat, we must add a login to our Tomcat server. We will do this by editing the tomcat-users.xml file:

    sudo vi /opt/tomcat/conf/tomcat-users.xml

This file is filled with comments which describe how to configure the file. You may want to delete all the comments between the following two lines, or you may leave them if you want to reference the examples:
tomcat-users.xml excerpt

<tomcat-users>
...
</tomcat-users>

You will want to add a user who can access the manager-gui and admin-gui (webapps that come with Tomcat). You can do so by defining a user similar to the example below. Be sure to change the username and password to something secure:
tomcat-users.xml — Admin User

<tomcat-users>
    <user username="admin" password="password" roles="manager-gui,admin-gui"/>
</tomcat-users>

Save and quit the tomcat-users.xml file.

By default, newer versions of Tomcat restrict access to the Manager and Host Manager apps to connections coming from the server itself. Since we are installing on a remote machine, you will probably want to remove or alter this restriction. To change the IP address restrictions on these, open the appropriate context.xml files.

For the Manager app, type:

    sudo vi /opt/tomcat/webapps/manager/META-INF/context.xml

For the Host Manager app, type:

    sudo vi /opt/tomcat/webapps/host-manager/META-INF/context.xml

Inside, comment out the IP address restriction to allow connections from anywhere. Alternatively, if you would like to allow access only to connections coming from your own IP address, you can add your public IP address to the list:
context.xml files for Tomcat webapps

<Context antiResourceLocking="false" privileged="true" >
  <!--<Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />-->
</Context>

Save and close the files when you are finished.

To put our changes into effect, restart the Tomcat service:

    sudo systemctl restart tomcat

Access the Web Interface

Now that Tomcat is up and running, let's access the web management interface in a web browser. You can do this by accessing the public IP address of the server, on port 8080:

Open in web browser:
http://server_IP_address:8080

