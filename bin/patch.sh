#!/bin/sh



# root tree with patch files

DIRNAME=$(dirname ${0})

PATCH_HOME="${DIRNAME}/../includes"
PUAVO_DIR_CHROOT="./puavo-dir-chroot"
PUAVO_DIR_CLONE="./puavo-dir-clone"

# test and save arg
if [ $# -ne 1 ]; then echo "usage: $0 IMAGE";exit;fi
IMG=$1

#cd /opt/ltsp/images/

if ! test -f ${IMG}.img; then
    echo "${IMG}.img not found. Did you cd to wright place?"
    exit 1
fi

# if exists, remove old ext4.img
#if [ -e ${IMG}.patch.img ]; then
#   echo -n "removing ${IMG}.patch.img ..." 
#   rm ${IMG}.patch.img
#   echo "ok"
#else
#   echo "no old image, ok."
#fi

# clone squashfs.img to ext4.img 
#echo -n "cloning ${IMG}.img to ${IMG}.patch.img ..."
#puavo-img-clone ${IMG}.img ${IMG}.patch.img
#echo "ok"


# make base image writable
echo "umounting ovrl and rofs"
umount ${IMG}.ovrl
umount ${IMG}.rofs
echo "cleaning rwfs" 
#clean rwfs
rm -r ${IMG}.rwfs/*

#make mountpounts
if ! test -d ${IMG}.ovrl; then mkdir ${IMG}.ovrl;fi
if ! test -d ${IMG}.rofs; then mkdir ${IMG}.rofs;fi
if ! test -d ${IMG}.rwfs; then mkdir ${IMG}.rwfs;fi


#mount image
mount -o loop ${IMG}.img ${IMG}.rofs
#mount -o loop ${IMG}.patch.img ${IMG}.rofs

#
mount -t overlayfs -o rw,upperdir=${IMG}.rwfs,lowerdir=${IMG}.rofs  overlayfs ${IMG}.ovrl



## create mountpoint for ext4.img and mount it
echo -n "copying files to ${IMG}.ovrl ..."


# copy patch files from PATCH_HOME to mount point
cp -r ${PATCH_HOME}/* ${IMG}.ovrl/.

# umount and remove mountpoint
#umount ${IMG}.mnt
#rmdir ${IMG}.mnt
echo "ok"



# run install-patch.sh in chroot
echo -n "patching ${IMG}.ovrl ..."
echo "sh /install/bin/install-patch.sh" | ${PUAVO_DIR_CHROOT} ${IMG}.ovrl
echo "ok"


## create mountpoint for ext4.img and mount it
echo -n "caching *.debs ..."
#mkdir ${IMG}.mnt
#mount -o loop ${IMG}.patch.img ${IMG}.mnt

# sync /var/cache/apt/archives/* to PATCH_HOME
if ! [ -d ${PATCH_HOME}/var/cache/apt/archives ]; then
   mkdir -p ${PATCH_HOME}/var/cache/apt/archives
fi
echo "rsync -rav  ${IMG}.mnt/var/cache/apt/archives/ ${PATCH_HOME}/var/cache/apt/archives"
rsync -rav  ${IMG}.ovrl/var/cache/apt/archives/ ${PATCH_HOME}/var/cache/apt/archives 

echo -n "removing unsued files ..."
# remove unused files
rm    ${IMG}.ovrl/var/cache/apt/archives/*.deb
rm -r ${IMG}.ovrl/install
echo "ok"

# umount and remove mountpoint
#umount ${IMG}.ovrl
#rmdir ${IMG}.mnt
echo "ok"

VERSION=$(date +%Y.%m.%d_%H.%M)
IMAGE="ltsp-amxa-${IMG}_${VERSION}.img"
# compress ext4.img to ./tmp/squashfs.img

echo -n "bulding  $IMAGE..."
${PUAVO_DIR_CLONE} -t squashfs ${IMG}.ovrl $IMAGE
echo "ok"

#umount ${IMG}.ovrl
#umount ${IMG}.rofs

# update bootserver
echo -n "updating nbd-exports and tftpboot ..."
#puavo-bootserver-generate-nbd-exports
#puavo-bootserver-update-tftpboot
echo "ok"

# bye
exit
