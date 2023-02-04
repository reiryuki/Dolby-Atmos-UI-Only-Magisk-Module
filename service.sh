MODPATH=${0%/*}
API=`getprop ro.build.version.sdk`

# debug
exec 2>$MODPATH/debug.log
set -x

# property
resetprop vendor.audio.dolby.ds2.enabled false
resetprop vendor.audio.dolby.ds2.hardbypass false
#resetprop vendor.audio.gef.debug.flags false
#resetprop vendor.audio.gef.enable.traces false
#resetprop vendor.dolby.dap.param.tee false
#resetprop vendor.dolby.mi.metadata.log false
#resetprop -n persist.vendor.dolby.loglevel 0

# restart
if [ "$API" -ge 24 ]; then
  SVC=audioserver
else
  SVC=mediaserver
fi
PID=`pidof $SVC`
if [ "$PID" ]; then
  killall $SVC
fi

# function
start_service() {
for NAMES in $NAME; do
  if [ "`getprop init.svc.$NAMES`" == stopped ]; then
    start $NAMES
  fi
done
}

# run
NAME="dms-hal-2-0 dms-hal-1-0"
start_service

# wait
until [ "`getprop sys.boot_completed`" == "1" ]; do
  sleep 10
done

# allow
PKG=com.dolby.daxappui
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi

# allow
PKG=com.dolby.daxservice
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi

# function
stop_log() {
FILE=$MODPATH/debug.log
SIZE=`du $FILE | sed "s|$FILE||"`
if [ "$LOG" != stopped ] && [ "$SIZE" -gt 50 ]; then
  exec 2>/dev/null
  LOG=stopped
fi
}
check_audioserver() {
if [ "$NEXTPID" ]; then
  PID=$NEXTPID
else
  PID=`pidof $SVC`
fi
sleep 10
stop_log
NEXTPID=`pidof $SVC`
if [ "`getprop init.svc.$SVC`" != stopped ]; then
  until [ "$PID" != "$NEXTPID" ]; do
    check_audioserver
  done
  killall $PROC
  check_audioserver
else
  start $SVC
  check_audioserver
fi
}

# check
if [ "$API" -ge 24 ]; then
  SVC=audioserver
else
  SVC=mediaserver
fi
PROC="com.dolby.daxservice com.dolby.daxappui"
killall $PROC
check_audioserver










