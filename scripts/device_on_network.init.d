#!/bin/bash

# device_on_network    Init script for device_on_network
# chkconfig: 345 99 75
#
# Description: Starts and Stops device_on_network: network scanner with API server

# Edit these
AS_USER="root"
APP_DIR="/opt/device_on_network"
LOG_FILE="/var/log/device_on_network"
PORT=12001

# Probably don't edit these
APP="device_on_network"
PID_GREP="ruby .*$APP"
START_CMD="bundle exec bin/device_on_network -p $PORT"
CMD="bash -lc 'cd ${APP_DIR}; ${START_CMD} >> ${LOG_FILE} 2>&1 &'"

RETVAL=0

start() {
  status
  if [ $? -eq 1 ]; then

    [ `id -u` == '0' ] || (echo "$APP runs as root only .."; exit 2)
    [ -d $APP_DIR ] || (echo "$APP_DIR not found!.. Exiting"; exit 3)

    cd $APP_DIR
    echo "Starting $APP..."
    su -c "$CMD" - $AS_USER
    RETVAL=$?
    return $RETVAL
  else
    echo "$APP is already running"
  fi
}

stop() {
  echo "Stopping $APP"
  SIG="INT"
  kill -$SIG $(pid)
  RETVAL=$?
  [ $RETVAL -eq 0 ] && rm -f $LOCK_FILE
  return $RETVAL
}

status() {
  ps -ef | grep "$PID_GREP" | grep -v grep
  return $?
}

pid() {
  ps -e -o pid,cmd | grep "$PID_GREP" | grep -v grep | awk '{print $1}'
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  status)
    status
    if [ $? -eq 0 ]; then
      echo "$APP is running (PID: ${pid})"
      RETVAL=0
    else
      echo "$APP is not running"
      RETVAL=1
    fi
    ;;
  *)
    echo "Usage: $0 {start|stop|status}"
    exit 0
    ;;
esac
exit $RETVAL
