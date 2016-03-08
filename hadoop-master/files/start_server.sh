#!/bin/bash
# Script to start the job server
set -e

get_abs_script_path() {
  pushd . >/dev/null
  cd $(dirname $0)
  appdir=$(pwd)
  popd  >/dev/null
}
get_abs_script_path

parentdir="$(dirname "$appdir")"

GC_OPTS="-XX:+UseConcMarkSweepGC
         -verbose:gc -XX:+PrintGCTimeStamps -Xloggc:$appdir/gc.out
         -XX:MaxPermSize=512m
         -XX:+CMSClassUnloadingEnabled "

JAVA_OPTS="-Xmx1g -XX:MaxDirectMemorySize=512M
           -XX:+HeapDumpOnOutOfMemoryError -Djava.net.preferIPv4Stack=true
           -Dcom.sun.management.jmxremote.authenticate=false
           -Dcom.sun.management.jmxremote.ssl=false"

MAIN="server.Main"

conffile="$parentdir/resources/application.conf"

if [ ! -f "$conffile" ]; then
  echo "No configuration file $conffile found"
  exit 1
fi

if [ -f "$parentdir/resources/settings.sh" ]; then
  . $parentdir/resources/settings.sh
else
  echo "Missing $parentdir/resources/settings.sh, exiting"
  exit 1
fi

if [ -z "$SPARK_HOME" ]; then
  echo "Please set SPARK_HOME or put it in $parentdir/resources/settings.sh first"
  exit 1
fi

# Pull in other env vars in spark config, such as MESOS_NATIVE_LIBRARY
. $SPARK_CONF_HOME/spark-env.sh


mkdir -p "${LOG_DIR}"

LOGGING_OPTS="-Dlog4j.configuration=log4j.properties
              -DLOG_DIR=$LOG_DIR
              -DLOG_FILE=spark-job-rest.log"

# For Mesos
#CONFIG_OVERRIDES="-Dspark.executor.uri=$SPARK_EXECUTOR_URI "
# For Mesos/Marathon, use the passed-in port
if [ -n "$PORT" ]; then
  CONFIG_OVERRIDES+="-Dspark.jobserver.port=$PORT "
fi

# The following should be exported in order to be accessible in Config substitutions
export SPARK_HOME
export APP_DIR
export JAR_PATH
export CONTEXTS_BASE_DIR

# job server jar needs to appear first so its deps take higher priority
# need to explicitly include app dir in classpath so logging configs can be found
#CLASSPATH="$appdir:$appdir/spark-job-server.jar:$($SPARK_HOME/bin/compute-classpath.sh)"

#CLASSPATH="$parentdir/resources:$appdir:$parentdir/spark-job-rest.jar:$($SPARK_HOME/bin/compute-classpath.sh)"
#echo "CLASSPATH = $CLASSPATH"


#exec java -cp $CLASSPATH $GC_OPTS $JAVA_OPTS $LOGGING_OPTS $CONFIG_OVERRIDES $MAIN $conffile  > /dev/null 2>&1 &
#echo $! > $appdir/server.pid


$SPARK_HOME/bin/spark-submit --class $MAIN --driver-memory 1G \
  --conf "spark.executor.extraJavaOptions=$LOGGING_OPTS" \
  --driver-java-options "$GC_OPTS $JAVA_OPTS $LOGGING_OPTS $CONFIG_OVERRIDES" \
  $@ $parentdir/spark-job-rest.jar $conffile 2>&1 &
 echo $! > $appdir/server.pid
