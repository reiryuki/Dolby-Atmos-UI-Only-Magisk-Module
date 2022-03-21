(

MODPATH=${0%/*}

resetprop vendor.audio.dolby.ds2.enabled false
resetprop vendor.audio.dolby.ds2.hardbypass false
#resetprop vendor.audio.gef.debug.flags true
#resetprop vendor.audio.gef.enable.traces true
#resetprop vendor.dolby.dap.param.tee true
#resetprop vendor.dolby.mi.metadata.log true

sleep 60

PROP=`getprop ro.build.version.sdk`

PKG=com.dolby.daxservice
pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
if [ "$PROP" -gt 29 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
PID=`pidof $PKG`
if [ $PID ]; then
  echo -17 > /proc/$PID/oom_adj
  echo -1000 > /proc/$PID/oom_score_adj
fi

) 2>/dev/null



