#!/bin/sh

if [ $# -ne 1 ]; then echo "usage: $0 IMAGE";exit;fi

IMG=$1




echo -n "bulding ${IMG}-bubendorf.img.tmp ..."
puavo-img-clone -t squashfs ${IMG}.patch.img ${IMG}-bubendorf.img.tmp
echo "ok"

if [ -e ${IMG}-bubendorf.img ]; then
   echo -n "removing ${IMG}-bubendorf.img ..." 
   rm ${IMG}-bubendorf.img
   echo "ok"
else
   echo "no old image, ok."
fi

echo -n "moving ${IMG}-bubendorf.img.tmp  to ${IMG}-bubendorf.img ..."
mv ${IMG}-bubendorf.img.tmp  ${IMG}-bubendorf.img
echo "ok"

echo -n "updating nbd-exports and tftpboot ..."
puavo-bootserver-generate-nbd-exports
puavo-bootserver-update-tftpboot
echo "ok"


exit