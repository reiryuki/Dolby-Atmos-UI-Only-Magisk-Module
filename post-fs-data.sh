mount -o rw,remount /data
MODPATH=${0%/*}

# log
exec 2>$MODPATH/debug-pfsd.log
set -x

# var
ABI=`getprop ro.product.cpu.abi`
if [ ! -d $MODPATH/vendor ]\
|| [ -L $MODPATH/vendor ]; then
  MODSYSTEM=/system
fi

# function
permissive() {
if [ "`toybox cat $FILE`" = 1 ]; then
  chmod 640 $FILE
  chmod 440 $FILE2
  echo 0 > $FILE
fi
}
magisk_permissive() {
if [ "`toybox cat $FILE`" = 1 ]; then
  if [ -x "`command -v magiskpolicy`" ]; then
	magiskpolicy --live "permissive *"
  else
	$MODPATH/$ABI/libmagiskpolicy.so --live "permissive *"
  fi
fi
}
sepolicy_sh() {
if [ -f $FILE ]; then
  if [ -x "`command -v magiskpolicy`" ]; then
    magiskpolicy --live --apply $FILE 2>/dev/null
  else
    $MODPATH/$ABI/libmagiskpolicy.so --live --apply $FILE 2>/dev/null
  fi
fi
}

# selinux
FILE=/sys/fs/selinux/enforce
FILE2=/sys/fs/selinux/policy
#1permissive
chmod 0755 $MODPATH/*/libmagiskpolicy.so
#2magisk_permissive
FILE=$MODPATH/sepolicy.rule
#ksepolicy_sh
FILE=$MODPATH/sepolicy.pfsd
sepolicy_sh

# directory
DIR=/data/vendor/dolby
mkdir -p $DIR
chmod 0770 $DIR
chown 1013.1013 $DIR
chcon u:object_r:vendor_data_file:s0 $DIR

# permission
DIRS=`find $MODPATH/vendor\
           $MODPATH/system/vendor -type d`
for DIR in $DIRS; do
  chown 0.2000 $DIR
done
chcon -R u:object_r:system_lib_file:s0 $MODPATH/system/lib*
chcon -R u:object_r:vendor_configs_file:s0 $MODPATH/system/odm/etc
chmod 0751 $MODPATH$MODSYSTEM/vendor/bin
chmod 0751 $MODPATH$MODSYSTEM/vendor/bin/hw
chmod 0755 $MODPATH$MODSYSTEM/vendor/odm/bin
chmod 0755 $MODPATH$MODSYSTEM/vendor/odm/bin/hw
FILES=`find $MODPATH$MODSYSTEM/vendor/bin\
            $MODPATH$MODSYSTEM/vendor/odm/bin -type f`
for FILE in $FILES; do
  chmod 0755 $FILE
  chown 0.2000 $FILE
done
FILES=`find $MODPATH$MODSYSTEM/vendor/lib* -type f`
for FILE in $FILES; do
  chmod 0644 $FILE
  chown 0.0 $FILE
done
chcon -R u:object_r:vendor_file:s0 $MODPATH$MODSYSTEM/vendor
chcon -R u:object_r:vendor_configs_file:s0 $MODPATH$MODSYSTEM/vendor/etc
chcon -R u:object_r:vendor_configs_file:s0 $MODPATH$MODSYSTEM/vendor/odm/etc
chcon u:object_r:vendor_hal_file:s0 $MODPATH$MODSYSTEM/vendor/lib*/hw
#chcon u:object_r:hal_dms_default_exec:s0 $MODPATH$MODSYSTEM/vendor/bin/hw/vendor.dolby*.hardware.dms*@*-service
#chcon u:object_r:hal_dms_default_exec:s0 $MODPATH$MODSYSTEM/vendor/odm/bin/hw/vendor.dolby*.hardware.dms*@*-service

# cleaning
FILE=$MODPATH/cleaner.sh
if [ -f $FILE ]; then
  . $FILE
  mv -f $FILE $FILE.txt
fi









