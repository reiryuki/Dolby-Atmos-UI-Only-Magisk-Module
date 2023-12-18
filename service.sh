MODPATH=${0%/*}

# log
LOGFILE=$MODPATH/debug.log
exec 2>$LOGFILE
set -x

# var
API=`getprop ro.build.version.sdk`

# property
resetprop -n vendor.audio.dolby.ds2.enabled false
resetprop -n vendor.audio.dolby.ds2.hardbypass false
#resetprop -n vendor.audio.gef.debug.flags false
#resetprop -n vendor.audio.gef.enable.traces false
#resetprop -n vendor.dolby.dap.param.tee false
#resetprop -n vendor.dolby.mi.metadata.log false
#resetprop -p --delete persist.vendor.dolby.loglevel
#resetprop -n persist.vendor.dolby.loglevel 0

# restart
if [ "$API" -ge 24 ]; then
  SERVER=audioserver
else
  SERVER=mediaserver
fi
PID=`pidof $SERVER`
if [ "$PID" ]; then
  killall $SERVER android.hardware.audio@4.0-service-mediatek
fi

# start
NAMES="dms-hal-2-0 dms-hal-1-0"
for NAME in $NAMES; do
  if [ "`getprop init.svc.$NAME`" == stopped ]; then
    start $NAME
  fi
done

# wait
until [ "`getprop sys.boot_completed`" == "1" ]; do
  sleep 10
done

# allow
PKG=com.dolby.daxappui
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
PKGOPS=`appops get $PKG`
UID=`dumpsys package $PKG 2>/dev/null | grep -m 1 userId= | sed 's|    userId=||g'`
if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
  UIDOPS=`appops get --uid "$UID"`
fi

# allow
PKG=com.dolby.daxservice
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
PKGOPS=`appops get $PKG`
UID=`dumpsys package $PKG 2>/dev/null | grep -m 1 userId= | sed 's|    userId=||g'`
if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
  UIDOPS=`appops get --uid "$UID"`
fi

# function
stop_log() {
SIZE=`du $LOGFILE | sed "s|$LOGFILE||g"`
if [ "$LOG" != stopped ] && [ "$SIZE" -gt 50 ]; then
  exec 2>/dev/null
  set +x
  LOG=stopped
fi
}
check_audioserver() {
if [ "$NEXTPID" ]; then
  PID=$NEXTPID
else
  PID=`pidof $SERVER`
fi
sleep 15
stop_log
NEXTPID=`pidof $SERVER`
if [ "`getprop init.svc.$SERVER`" != stopped ]; then
  [ "$PID" != "$NEXTPID" ] && killall $PROC
else
  start $SERVER
fi
check_audioserver
}

# check
PROC="com.dolby.daxservice com.dolby.daxappui"
killall $PROC
check_audioserver










