(

mount /data
mount -o rw,remount /data
MODPATH=${0%/*}

# debug
magiskpolicy --live "dontaudit system_server system_file file write"
magiskpolicy --live "allow     system_server system_file file write"
exec 2>$MODPATH/debug-pfsd.log
set -x

# run
FILE=$MODPATH/sepolicy.sh
if [ -f $FILE ]; then
  sh $FILE
fi

# directory
DIR=/data/vendor/dolby
if [ ! -d $DIR ]; then
  mkdir -p $DIR
fi
chmod 0770 $DIR
chown 1013.1013 $DIR
magiskpolicy --live "dontaudit vendor_data_file labeledfs filesystem associate"
magiskpolicy --live "allow     vendor_data_file labeledfs filesystem associate"
magiskpolicy --live "dontaudit init vendor_data_file dir relabelfrom"
magiskpolicy --live "allow     init vendor_data_file dir relabelfrom"
magiskpolicy --live "dontaudit init vendor_data_file file relabelfrom"
magiskpolicy --live "allow     init vendor_data_file file relabelfrom"
chcon u:object_r:vendor_data_file:s0 $DIR

# cleaning
FILE=$MODPATH/cleaner.sh
if [ -f $FILE ]; then
  sh $FILE
  rm -f $FILE
fi

) 2>/dev/null




