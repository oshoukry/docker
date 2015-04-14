#!/bin/sh

set -x 

# ===================== #
# Script configuration. #
# ===================== #

# Container Name: tcws = Tomcat Web Server
DOCKER_CONTAINER_NAME=tcws

# Set the JAVA version
JAVA_MAJOR_VERSION=8
JAVA_UPDATE_VERSION=40
JAVA_BUILD_NUMBER=26

# Possible values here [jdk|jre]
JAVA_DISTRIBUTION=jre

# Set the default memory in the container
JVM_MEMORY=1024m

# Set the tomcat version
TOMCAT_MAJOR_VERSION=8
TOMCAT_MINOR_VERSION=0.21

# Set the default ports for tomcat.
SHUTDOWN_PORT=8005
LISTEN_PORT=8080
REDIRECT_PORT=8443
AJP_PORT=8009
JMX_PORT=8050

# ============================ #
# End of Script configuration. #
# ============================ #

JAVA_DOWNLOAD_SRC=http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-b${JAVA_BUILD_NUMBER}/${JAVA_DISTRIBUTION}-${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}-linux-x64.tar.gz
TOMCAT_DOWNLOAD_SRC=https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION}.tar.gz


DOCKER_ORIGIN=progrium/busybox

if [ $JAVA_DISTRIBUTION = "jdk" ]; then
  JREPATH=jre
fi

cat - >Dockerfile.1 <<EOF
FROM ${DOCKER_ORIGIN}

MAINTAINER Osman Shoukry <oshoukry@openpojo.com>

RUN opkg-install wget
RUN ln -sf /lib/libpthread-2.18.so /lib/libpthread.so.0

# INSTALL JAVA
RUN wget \
		--no-check-certificate \
		--header "Cookie: oraclelicense=accept-securebackup-cookie" \
		${JAVA_DOWNLOAD_SRC} \
		--output-document=/tmp/${JAVA_DISTRIBUTION}.tar.gz \
	&& gunzip /tmp/${JAVA_DISTRIBUTION}.tar.gz \
	&& cd /opt \
	&& tar xf /tmp/${JAVA_DISTRIBUTION}.tar \
	&& rm -rf /tmp/${JAVA_DISTRIBUTION}.tar \
	&& ln -sf /opt/${JAVA_DISTRIBUTION}1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION} /java

ENV JAVA_HOME /java

# Remove unnecessary desktop, sources & other artifacts from Java.
RUN rm -rf \
	/java/*src.zip \
	/java/lib/missioncontrol \
	/java/lib/visualvm \
	/java/lib/*javafx* \
	/java/${JREPATH}/lib/plugin.jar \
	/java/${JREPATH}/lib/ext/jfxrt.jar \
	/java/${JREPATH}/bin/javaws \
	/java/${JREPATH}/lib/javaws.jar \
	/java/${JREPATH}/lib/desktop \
	/java/${JREPATH}/plugin \
	/java/${JREPATH}/lib/deploy* \
	/java/${JREPATH}/lib/*javafx* \
	/java/${JREPATH}/lib/*jfx* \
	/java/${JREPATH}/lib/amd64/libdecora_sse.so \
	/java/${JREPATH}/lib/amd64/libprism_*.so \
	/java/${JREPATH}/lib/amd64/libfxplugins.so \
	/java/${JREPATH}/lib/amd64/libglass.so \
	/java/${JREPATH}/lib/amd64/libgstreamer-lite.so \
	/java/${JREPATH}/lib/amd64/libjavafx*.so \
	/java/${JREPATH}/lib/amd64/libjfx*.so

# INSTALL TOMCAT
RUN wget \
		--no-check-certificate \
		${TOMCAT_DOWNLOAD_SRC} \
	&& wget \
		--no-check-certificate \
		-qO- ${TOMCAT_DOWNLOAD_SRC}.md5 \
	| md5sum -c - \
	&& gunzip apache-tomcat-${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION}.tar.gz \
        && tar xf apache-tomcat-${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION}.tar \
        && rm apache-tomcat-${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION}.tar \
        && mv apache-tomcat-${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION} /opt/ \
	&& ln -sf /opt/apache-tomcat-${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION} /tomcat \
	&& rm -rf /tomcat/webapps/*


ENV CATALINA_HOME /tomcat
EOF

cat - >> Dockerfile.1 <<'EOF'
ENV PATH /java/bin/:$PATH

# Allow Tomcat port override through environment variables.
RUN cat /tomcat/conf/server.xml \
		|sed 's/Server port="8005"/Server port="${SHUTDOWN_PORT}"/g' \
		|sed 's/Connector port="8080"/Connector port="${LISTEN_PORT}"/g' \
		|sed 's/redirectPort="8443"/redirectPort="${REDIRECT_PORT}"/g' \
		|sed 's/Connector port="8009" protocol="AJP\/1.3"/Connector port="${AJP_PORT}" protocol="AJP\/1.3"/g' > /tomcat/conf/server.xml.new \
	&& mv /tomcat/conf/server.xml.new /tomcat/conf/server.xml

ADD build.sh /opt/image_build_script.sh

ADD tomcat/run.sh /run.sh
RUN chmod +x /run.sh

EOF

##################################################################################
# The sole purpose of creating another Dockerfile and utilizing it is to restore #
# the environment variables that get lost when we purge the history perhaps a    #
# future feature in docker to export ENV variable will render this obsolete,     #
# for now this is the only way.                                                  #
##################################################################################

cat - > Dockerfile.2 <<EOF
FROM ${DOCKER_CONTAINER_NAME}

MAINTAINER Osman Shoukry <oshoukry@openpojo.com>

ENV DOCKER_ORIGIN ${DOCKER_ORIGIN}
ENV JAVA_MAJOR_VERSION ${JAVA_MAJOR_VERSION}
ENV JAVA_UPDATE_VERSION ${JAVA_UPDATE_VERSION}
ENV JAVA_BUILD_NUMBER ${JAVA_BUILD_NUMBER}
ENV JAVA_DISTRIBUTION ${JAVA_DISTRIBUTION}
ENV JAVA_DOWNLOAD_SRC ${JAVA_DOWNLOAD_SRC}
ENV JAVA_HOME /java

ENV JVM_MEMORY ${JVM_MEMORY}

ENV TOMCAT_MAJOR_VERSION ${TOMCAT_MAJOR_VERSION}
ENV TOMCAT_MINOR_VERSION ${TOMCAT_MINOR_VERSION}
ENV TOMCAT_DOWNLOAD_SRC ${TOMCAT_DOWNLOAD_SRC}
ENV CATALINA_HOME /tomcat

ENV SHUTDOWN_PORT ${SHUTDOWN_PORT}
ENV LISTEN_PORT ${LISTEN_PORT}
ENV REDIRECT_PORT ${REDIRECT_PORT}
ENV AJP_PORT ${AJP_PORT}
ENV JMX_PORT ${JMX_PORT}

EOF

cat - >> Dockerfile.2 <<'EOF'
ENV PATH $JAVA_HOME/bin/:$PATH

CMD ["/run.sh"]
EOF

cat Dockerfile.1 > Dockerfile \
	&& docker build -t ${DOCKER_CONTAINER_NAME} ./ \
	&& docker run --cidfile=container_id ${DOCKER_CONTAINER_NAME} echo ${DOCKER_CONTAINER_NAME} Created, now cleaning history \
	&& docker export `cat container_id` | docker import - ${DOCKER_CONTAINER_NAME} \
	&& cat Dockerfile.2 > Dockerfile \
	&& docker build -t ${DOCKER_CONTAINER_NAME} ./ \
	&& docker rm `docker ps -a -q |sed -n '1p'` \
	&& docker rmi `docker images -f 'dangling=true' -q |sed -n '1p'` \
	&& rm -rf Dockerfile Dockerfile.1 Dockerfile.2 container_id

# ============================ #
# Push container to repository #
# ============================ #
case $1 in
  push)
    REPOSITORY=$2
    if [ "x${REPOSITORY}" = "x" ]; then
      echo "ERROR: Unspecified repository location to push container to, push failed!!"
      exit 1
    fi
    VERSION=$3
    if [ "x${VERSION}" = "x" ]; then
      echo "ERROR: Unspecified version, push failed!!"
      exit 1
    fi

    TARGET=${REPOSITORY}/${DOCKER_CONTAINER_NAME}:${VERSION}
    LATEST=${REPOSITORY}/${DOCKER_CONTAINER_NAME}:latest

    echo "INFO: Tagging '${DOCKER_CONTAINER_NAME}' as '${TARGET}'"
    docker tag ${DOCKER_CONTAINER_NAME} ${TARGET} \
      && echo "INFO: Pushing to '${DOCKER_CONTAINER_NAME}' to '${TARGET}'" \
      && docker push ${TARGET}

    echo "INFO: Tagging '${TARGET}' as '${LATEST}'"
    docker tag ${TARGET} ${LATEST} \
      && echo "INFO: Pushing to '${TARGET}' to '${LATEST}" \
      && docker push ${LATEST} \
      && docker rmi ${DOCKER_CONTAINER_NAME}
    ;;
esac
