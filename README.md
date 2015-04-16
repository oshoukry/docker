# Small docker container with JRE & Tomcat
A repository for simplified docker container builds

### Why?
The challenge was to build the smallest possible Docker container that includes the JRE and Tomcat.
** There are 3 main components used here **
  1. progrium/busybox (~5MB)
  2. JRE (~110MB - after trimming)
  3. Tomcat (~9MB - without war files)

#### Final size of the container = 126.8MB

### How to build it?
  1. Install docker
  2. Run ./build.sh

If you'd like to customize which JVM or Tomcat to use, or change any of the default startup parameters edit build.sh.<br>
It is currently set to build with Java JRE 1.8.0_40, Tomcat 8.0.21.

#### Advanced options, JAVA & Tomcat control through environment variables.
``` SH
  # This will start the container and set the JVM memory to 2048, default is 1024m
  docker run -d -e JVM_MEMORY=2048m tcws
```
##### Environment Variables
  1. **JVM_MEMORY:** default is set to 1024m, but you can over ride with any value you desire.
  2. **TOMCAT_PASS:** no default, will be randomly generated and dropped in the console output.
  2. **LISTEN_PORT:** default is 8080, this is the port for incoming http traffic to Tomcat.
  3. **SHUTDOWN_PORT:** default is 8005.
  4. **JMX_PORT:** default is 8050
  5. **AJP_PORT:** default is 8009
  6. **REDIRECT_PORT:** default is 8443

Here is a sample output from tomcat when it starts - **549 ms startup time!!**
```
INFO: TOMCAT_PASS variable unset, creating a random password
INFO: Creating an admin user with a UzyjrGbA password in Tomcat
========================================================================
You can now configure to this Tomcat server using:

 User: admin
 Pass: UzyjrGbA

========================================================================
14-Apr-2015 04:04:21.644 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version:        Apache Tomcat/8.0.21
14-Apr-2015 04:04:21.645 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server built:          Mar 23 2015 14:11:21 UTC
14-Apr-2015 04:04:21.645 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server number:         8.0.21.0
14-Apr-2015 04:04:21.645 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Name:               Linux
14-Apr-2015 04:04:21.645 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Version:            3.18.5-tinycore64
14-Apr-2015 04:04:21.646 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Architecture:          amd64
14-Apr-2015 04:04:21.646 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Java Home:             /opt/jre1.8.0_40
14-Apr-2015 04:04:21.646 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Version:           1.8.0_40-b26
14-Apr-2015 04:04:21.646 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Vendor:            Oracle Corporation
14-Apr-2015 04:04:21.646 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_BASE:         /opt/apache-tomcat-8.0.21
14-Apr-2015 04:04:21.646 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_HOME:         /opt/apache-tomcat-8.0.21
14-Apr-2015 04:04:21.646 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.config.file=/tomcat/conf/logging.properties
14-Apr-2015 04:04:21.646 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
14-Apr-2015 04:04:21.647 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Xms1024m
14-Apr-2015 04:04:21.647 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Xmx1024m
14-Apr-2015 04:04:21.647 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -DSHUTDOWN_PORT=8005
14-Apr-2015 04:04:21.647 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -DLISTEN_PORT=8080
14-Apr-2015 04:04:21.647 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -DREDIRECT_PORT=8443
14-Apr-2015 04:04:21.647 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -DAJP_PORT=8009
14-Apr-2015 04:04:21.647 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -DJMX_PORT=8050
14-Apr-2015 04:04:21.647 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.endorsed.dirs=/tomcat/endorsed
14-Apr-2015 04:04:21.647 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.base=/tomcat
14-Apr-2015 04:04:21.647 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.home=/tomcat
14-Apr-2015 04:04:21.647 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.io.tmpdir=/tomcat/temp
14-Apr-2015 04:04:21.648 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent The APR based Apache Tomcat Native library which allows optimal performance in production environments was not found on the java.library.path: /usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib
14-Apr-2015 04:04:21.783 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["http-nio-8080"]
14-Apr-2015 04:04:21.799 INFO [main] org.apache.tomcat.util.net.NioSelectorPool.getSharedSelector Using a shared selector for servlet write/read
14-Apr-2015 04:04:21.802 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["ajp-nio-8009"]
14-Apr-2015 04:04:21.803 INFO [main] org.apache.tomcat.util.net.NioSelectorPool.getSharedSelector Using a shared selector for servlet write/read
14-Apr-2015 04:04:21.805 INFO [main] org.apache.catalina.startup.Catalina.load Initialization processed in 505 ms
14-Apr-2015 04:04:21.830 INFO [main] org.apache.catalina.core.StandardService.startInternal Starting service Catalina
14-Apr-2015 04:04:21.831 INFO [main] org.apache.catalina.core.StandardEngine.startInternal Starting Servlet Engine: Apache Tomcat/8.0.21
14-Apr-2015 04:04:21.841 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
14-Apr-2015 04:04:21.847 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["ajp-nio-8009"]
14-Apr-2015 04:04:21.850 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in 44 ms
```
