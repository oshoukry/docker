# Small docker container with JRE & Tomcat
A repository for simplified docker container builds

### Why?
The challenge was to build the smallest possible Docker container that includes the JRE and Tomcat.
#### There are 3 main components used here
  1. progrium/busybox (~5MB)
  2. JRE (~110MB - after trimming)
  3. Tomcat (~9MB - without war files)

#### Final size of the container = 126.8MB

### How to build it?
  1. Install docker
  2. Run ./build.sh

If you'd like to customize which JVM or Tomcat to use, or change any of the default startup parameters edit build.sh.<br>
It is currently set to build with Java JRE 8u45-b14, Tomcat 8.0.21.

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

Here is a sample output from tomcat when it starts - **539 ms startup time!!**
``` LOG
INFO: TOMCAT_PASS variable unset, creating a random password
INFO: Creating an admin user with a eAxmOkMb password in Tomcat
========================================================================
You can now configure to this Tomcat server using:

 User: admin
 Pass: eAxmOkMb

========================================================================
26-Apr-2015 03:15:44.137 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server version:        Apache Tomcat/8.0.21
26-Apr-2015 03:15:44.139 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server built:          Mar 23 2015 14:11:21 UTC
26-Apr-2015 03:15:44.139 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Server number:         8.0.21.0
26-Apr-2015 03:15:44.139 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Name:               Linux
26-Apr-2015 03:15:44.139 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log OS Version:            3.18.5-tinycore64
26-Apr-2015 03:15:44.140 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Architecture:          amd64
26-Apr-2015 03:15:44.141 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Java Home:             /opt/jre1.8.0_45
26-Apr-2015 03:15:44.144 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Version:           1.8.0_45-b14
26-Apr-2015 03:15:44.145 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log JVM Vendor:            Oracle Corporation
26-Apr-2015 03:15:44.145 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_BASE:         /opt/apache-tomcat-8.0.21
26-Apr-2015 03:15:44.145 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log CATALINA_HOME:         /opt/apache-tomcat-8.0.21
26-Apr-2015 03:15:44.145 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.config.file=/tomcat/conf/logging.properties
26-Apr-2015 03:15:44.145 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager
26-Apr-2015 03:15:44.145 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Xms1024m
26-Apr-2015 03:15:44.145 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Xmx1024m
26-Apr-2015 03:15:44.145 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -DSHUTDOWN_PORT=8005
26-Apr-2015 03:15:44.145 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -DLISTEN_PORT=8080
26-Apr-2015 03:15:44.145 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -DREDIRECT_PORT=8443
26-Apr-2015 03:15:44.145 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -DAJP_PORT=8009
26-Apr-2015 03:15:44.146 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -DJMX_PORT=8050
26-Apr-2015 03:15:44.146 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.endorsed.dirs=/tomcat/endorsed
26-Apr-2015 03:15:44.146 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.base=/tomcat
26-Apr-2015 03:15:44.146 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Dcatalina.home=/tomcat
26-Apr-2015 03:15:44.146 INFO [main] org.apache.catalina.startup.VersionLoggerListener.log Command line argument: -Djava.io.tmpdir=/tomcat/temp
26-Apr-2015 03:15:44.146 INFO [main] org.apache.catalina.core.AprLifecycleListener.lifecycleEvent The APR based Apache Tomcat Native library which allows optimal performance in production environments was not found on the java.library.path: /usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib
26-Apr-2015 03:15:44.268 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["http-nio-8080"]
26-Apr-2015 03:15:44.284 INFO [main] org.apache.tomcat.util.net.NioSelectorPool.getSharedSelector Using a shared selector for servlet write/read
26-Apr-2015 03:15:44.286 INFO [main] org.apache.coyote.AbstractProtocol.init Initializing ProtocolHandler ["ajp-nio-8009"]
26-Apr-2015 03:15:44.287 INFO [main] org.apache.tomcat.util.net.NioSelectorPool.getSharedSelector Using a shared selector for servlet write/read
26-Apr-2015 03:15:44.289 INFO [main] org.apache.catalina.startup.Catalina.load Initialization processed in 493 ms
26-Apr-2015 03:15:44.315 INFO [main] org.apache.catalina.core.StandardService.startInternal Starting service Catalina
26-Apr-2015 03:15:44.315 INFO [main] org.apache.catalina.core.StandardEngine.startInternal Starting Servlet Engine: Apache Tomcat/8.0.21
26-Apr-2015 03:15:44.325 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["http-nio-8080"]
26-Apr-2015 03:15:44.332 INFO [main] org.apache.coyote.AbstractProtocol.start Starting ProtocolHandler ["ajp-nio-8009"]
26-Apr-2015 03:15:44.336 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in 46 ms
```
