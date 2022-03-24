(

mount /data
mount -o rw,remount /data
MODPATH=${0%/*}

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
magiskpolicy "dontaudit vendor_data_file labeledfs filesystem associate"
magiskpolicy "allow     vendor_data_file labeledfs filesystem associate"
magiskpolicy "dontaudit init vendor_data_file dir relabelfrom"
magiskpolicy "allow     init vendor_data_file dir relabelfrom"
magiskpolicy "dontaudit init vendor_data_file file relabelfrom"
magiskpolicy "allow     init vendor_data_file file relabelfrom"
chcon u:object_r:vendor_data_file:s0 $DIR
magiskpolicy --live "type vendor_data_file"

# cleaning
FILE=$MODPATH/cleaner.sh
if [ -f $FILE ]; then
  sh $FILE
  rm -f $FILE
fi

) 2>/dev/null




