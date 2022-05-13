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
killall audioserver

# function
run_service() {
if getprop | grep "init.svc.$NAME\]: \[stopped"; then
  start $NAME
fi
}

# run
#NAME=dms-v36-hal-2-0
#run_service
NAME=dms-hal-2-0
run_service
NAME=dms-hal-1-0
run_service

# wait
sleep 60

# allow
PKG=com.dolby.daxappui
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi

# allow
PKG=com.dolby.daxservice
if pm list packages | grep $PKG ; then
  if [ "$API" -ge 30 ]; then
    appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
  fi
fi


