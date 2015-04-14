#!/bin/sh

if [ ! -f /.tomcat_admin_created ]; then
  PASS=${TOMCAT_PASS}
  if [ "x$PASS" = "x" ]; then
    echo "INFO: TOMCAT_PASS variable unset, creating a random password"
    PASS=`tr -dc "[:alpha:]" < /dev/urandom | head -c 8`
  fi

  echo "INFO: Creating an admin user with a ${PASS} password in Tomcat"

  TOMCAT_USERS_FILE=${CATALINA_HOME}/conf/tomcat-users.xml

  sed -i -r 's/<\/tomcat-users>//' ${TOMCAT_USERS_FILE}
cat - >> ${TOMCAT_USERS_FILE} <<EOF
  <role rolename="manager-gui"/>
  <role rolename="manager-script"/>
  <role rolename="manager-jmx"/>
  <role rolename="admin-gui"/>
  <role rolename="admin-script"/>
  <user username="admin" password="${PASS}" roles="manager-gui, manager-script, manager-jmx, admin-gui, admin-script"/>
</tomcat-users>
EOF

  CREATED=`cat ${TOMCAT_USERS_FILE} |grep "password=\"${PASS}\"" |wc -l`
  if [ $CREATED -gt 0 ]; then
    touch /.tomcat_admin_created
  else
    echo "ERROR: Failed to create admin user, abandoning run"
    exit 1
  fi

  echo "========================================================================"
  echo "You can now configure to this Tomcat server using:"
  echo ""
  echo " User: admin"
  echo " Pass: ${PASS}"
  echo ""
  echo "========================================================================"
fi

## Configure JAVA_OPTS
export JAVA_OPTS="\
	-Xms${JVM_MEMORY} \
	-Xmx${JVM_MEMORY}"

## Configure CATALINA_OPTS
export CATALINA_OPTS="\
	-DSHUTDOWN_PORT=${SHUTDOWN_PORT} \
	-DLISTEN_PORT=${LISTEN_PORT} \
	-DREDIRECT_PORT=${REDIRECT_PORT} \
	-DAJP_PORT=${AJP_PORT} \
	-DJMX_PORT=${JMX_PORT}"

exec ${CATALINA_HOME}/bin/catalina.sh run
