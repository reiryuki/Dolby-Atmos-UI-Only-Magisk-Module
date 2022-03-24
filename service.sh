(

MODPATH=${0%/*}
API=`getprop ro.build.version.sdk`

resetprop vendor.audio.dolby.ds2.enabled false
resetprop vendor.audio.dolby.ds2.hardbypass false
#resetprop vendor.audio.gef.debug.flags false
#resetprop vendor.audio.gef.enable.traces false
#resetprop vendor.dolby.dap.param.tee false
#resetprop vendor.dolby.mi.metadata.log false
#resetprop -n persist.vendor.dolby.loglevel 0

sleep 60

PKG=com.dolby.daxappui
if [ "$API" -gt 29 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
PKG=com.dolby.daxservice
if [ "$API" -gt 29 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
PID=`pidof $PKG`
if [ $PID ]; then
  echo -17 > /proc/$PID/oom_adj
  echo -1000 > /proc/$PID/oom_score_adj
fi

) 2>/dev/null



