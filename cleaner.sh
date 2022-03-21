PKG="com.dolby.daxappui
     com.dolby.daxservice"
for PKGS in $PKG; do
  rm -rf /data/user/*/$PKGS/cache/*
done


