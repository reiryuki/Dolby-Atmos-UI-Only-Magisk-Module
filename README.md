# Dolby Atmos User Interface Only Magisk Module

## DISCLAIMER
- Dolby apps and blobs are owned by Dolby™.
- The MIT license specified here is for the Magisk Module only, not for Dolby apps and blobs.

## Descriptions
Dolby Atmos equalizer user interface app only for any ROM that has in-built Dolby Audio Processing sound effect and service.

## Changelog

v2.2
- Update libmagiskpolicy.so from Magisk (stable) 30.7 (30700)
- Resets module folders/files permissions at post-fs-data
- Move _uninstall.log to /data/adb/logs/
- Hides LunarisDolby.apk

v2.1
- Fix a crash in Miui ROM
- Fix wrong target in latest KernelSU

v2.0
- Fix UUID detection
- Fix integrity failure if using permissive.mode=1
- Add Dolby Optionals support
- Abort installation if fail to mount mirror system

v1.19
- Move apk to priv-app
- Add Action button to clear apps caches
- Fix bug in uninstall.sh

v1.18
- Fix selinux denials

v1.17
- Fix conflict with modules_update while installing via recovery if Magisk installed
- Fix MagiskHide & SUList

v1.16
- Add new Magisk and Kitsune Mask support (independent mirror)
- Remount partitions before mounting mirror to prevent mount failure caused by device/resource busy
- Removes conflicted modules

v1.15
- Redirect /storage/emulated to /data/media

v1.14
- Redirect /sdcard to /storage/emulated/"$UID"
- Fix MagiskHide & SUList
- Update sepolicy rules

v1.13
- Sets system property ro.audio.monitorWindowRotation=true if audio.rotation=1 at optionals.prop
- Fix fatal exceptions

## Screenshots
- https://t.me/androidryukimodsdiscussions/66074

## Requirements
- Android 9 and up
- Supported ROM in-built Dolby Audio Processing sound effect with dms-hal-2-0 or dms-hal-1-0 service
- Magisk or Kitsune Mask or KernelSU or Apatch installed

## Installation Guide & Download Link
- If you are using KernelSU, you need to disable Unmount Modules by Default in KernelSU app settings and install https://github.com/KernelSU-Modules-Repo/meta-overlayfs or https://github.com/KernelSU-Modules-Repo/magic_mount_rs or https://github.com/KernelSU-Modules-Repo/hybrid_mount or https://github.com/maxsteeel/nomount first depending on ROM compatibility
- Install this module https://devuploads.com/kn7lobeq09ve via Magisk app or KernelSU app or Apatch app only
- Reboot
- If you are using KernelSU, you need to allow superuser list manually all package name listed in package.txt (and your home launcher app also) (enable show system apps) and reboot afterwards
- If you are using SUList, you need to allow list manually your home launcher app (enable show system apps) and reboot afterwards

## Optionals
- https://t.me/ryukinotes/8
- Global: https://t.me/ryukinotes/35

## Troubleshootings
- https://t.me/ryukinotes/11
- Global: https://t.me/ryukinotes/34

## Support & Bug Report
- https://t.me/ryukinotes/54
- If you don't do above, issues will be closed immediately

## Credits and Contributors
- @HuskyDG
- https://t.me/viperatmos
- https://t.me/androidryukimodsdiscussions
- You can contribute ideas about this Magisk Module here: https://t.me/androidappsportdevelopment

## Sponsors
- https://t.me/ryukinotes/25


