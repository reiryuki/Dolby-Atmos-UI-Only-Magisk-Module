MODPATH=${0%/*}

# log
LOGFILE=$MODPATH/debug.log
exec 2>$LOGFILE
set -x

# var
API=`getprop ro.build.version.sdk`

# property
resetprop -n ro.audio.ignore_effects false
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
killall $SERVER\
 android.hardware.audio@4.0-service-mediatek\
 android.hardware.audio.service

# restart
NAMES="dms-hal-2-0 dms-hal-1-0"
for NAME in $NAMES; do
  if [ "`getprop init.svc.$NAME`" == stopped ]; then
    start $NAME
  elif [ "`getprop init.svc.$NAME`" == running ]\
  || [ "`getprop init.svc.$NAME`" == restarting ]; then
    killall vendor.dolby.hardware.dms@2.0-service\
     vendor.dolby.hardware.dms@1.0-service
  fi
done

# wait
until [ "`getprop sys.boot_completed`" == 1 ]; do
  sleep 10
done

# list
PKGS=`cat $MODPATH/package.txt`
for PKG in $PKGS; do
  magisk --denylist rm $PKG 2>/dev/null
  magisk --sulist add $PKG 2>/dev/null
done
if magisk magiskhide sulist; then
  for PKG in $PKGS; do
    magisk magiskhide add $PKG
  done
else
  for PKG in $PKGS; do
    magisk magiskhide rm $PKG
  done
fi

# allow
PKG=com.dolby.daxappui
if appops get $PKG >/dev/null 2>&1; then
  if [ "$API" -ge 30 ]; then
    appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
  fi
  PKGOPS=`appops get $PKG`
  UID=`grep "^$PKG " /data/system/packages.list | awk '{print $2}'`
  if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
    UIDOPS=`appops get --uid "$UID"`
  fi
fi

# allow
PKG=com.dolby.daxservice
if appops get $PKG >/dev/null 2>&1; then
  if [ "$API" -ge 30 ]; then
    appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
  fi
  PKGOPS=`appops get $PKG`
  UID=`grep "^$PKG " /data/system/packages.list | awk '{print $2}'`
  if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
    UIDOPS=`appops get --uid "$UID"`
  fi
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
[ "$PID" != "$NEXTPID" ] && killall $PROC
check_audioserver
}

# check
PROC=`cat $MODPATH/package.txt`
killall $PROC
check_audioserver










