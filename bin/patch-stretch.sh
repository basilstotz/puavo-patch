#!/bin/sh

if test "$2" = "free"; then
  FREE="1"
else
  FREE="0"
fi


#apt-get --yes install qemu-kvm squashfs-tools aufs-tools

apt-get --yes install squashfs-tools


if ! modprobe overlay; then
  echo "no overlay fs"
  exit 1
fi

# root tree with patch files

DIRNAME=$(dirname ${0})

PATCH_HOME="${DIRNAME}/../includes"
PUAVO_DIR_CHROOT="./puavo-dir-chroot"
#PUAVO_DIR_CLONE="./puavo-dir-clone"

# test and save arg
if [ $# -eq 0 ]; then echo "usage: $0 IMAGE";exit;fi
IMG=$1

#cd /opt/ltsp/images/

if ! test -f ${IMG}.img; then
    echo "${IMG}.img not found. Did you cd to wright place?"
    exit 1
fi


# clone squashfs.img to ext4.img 
#puavo-img-clone ${IMG}.img ${IMG}.patch.img


echo "umounting ovrl and rofs"
umount ${IMG}.ovrl
umount ${IMG}.rofs

if  test -d ${IMG}.work; then rm -r ${IMG}.work;fi

#rm -r tmp.* &

#make mountpounts
if ! test -d ${IMG}.ovrl; then mkdir ${IMG}.ovrl;fi
if ! test -d ${IMG}.rofs; then mkdir ${IMG}.rofs;fi
if ! test -d ${IMG}.rwfs; then mkdir ${IMG}.rwfs;fi
if ! test -d ${IMG}.work; then mkdir ${IMG}.work;fi

echo "updating rwfs" 
#clean rwfs
rm -r ${IMG}.rwfs/*





# make base image writable

#mount image
mount -r -o loop ${IMG}.img ${IMG}.rofs
#mount -o loop ${IMG}.patch.img ${IMG}.rofs

#
# mount -t overlayfs -o rw,upperdir=${IMG}.rwfs,lowerdir=${IMG}.rofs  overlayfs ${IMG}.ovrl


#mount -t aufs -o br=${IMG}.rwfs:${IMG}.rofs aufs ${IMG}.ovrl

# mount -t overlayfs -o rw,upperdir=${IMG}.rwfs,lowerdir=${IMG}.rofs  overlayfs ${IMG}.ovrl

mount -t overlay   overlay -olowerdir=${IMG}.rofs,upperdir=${IMG}.rwfs,workdir=${IMG}.work  ${IMG}.ovrl



echo -n "copying files to ${IMG}.ovrl ..."

###########################################################################
# copy patch files from PATCH_HOME to mount point

#old
cp -r  ${PATCH_HOME}/var ${IMG}.ovrl/.
cp -r  ${PATCH_HOME}/root ${IMG}.ovrl/.

cp -r  ${PATCH_HOME}/install ${IMG}.ovrl/.

#mkdir -p ${IMG}.ovrl/install
#mount -o bind ${PATCH_HOME}/install ${IMG}.ovrl/install
#mount -o remount,ro ${IMG}.ovrl/install

#new
#cp -r  ${PATCH_HOME}/root/.ssh ${IMG}.ovrl/root/.
#mkdir ${IMG}.ovrl/install
#mount --bind  ${PATCH_HOME}/install

##########################################################################


# umount and remove mountpoint
#umount ${IMG}.mnt
#rmdir ${IMG}.mnt
echo "ok"

#umount ${IMG}.ovrl/install

#exit

# run install-patch.sh in chroot
echo -n "patching ${IMG}.ovrl ..."
if test "$FREE" = "0"; then
  echo "sh /install/bin/install-patch-stretch.sh" | ${PUAVO_DIR_CHROOT} ${IMG}.ovrl
else
  echo "sh /install/bin/install-patch-stretch.sh free" | ${PUAVO_DIR_CHROOT} ${IMG}.ovrl
fi
echo "ok"


#########################################################################
echo -n "caching *.debs ..."
# sync /var/cache/apt/archives/* to PATCH_HOME
if ! [ -d ${PATCH_HOME}/var/cache/apt/archives ]; then
   mkdir -p ${PATCH_HOME}/var/cache/apt/archives
fi
echo "rsync -rav  ${IMG}.ovrl/var/cache/apt/archives/ ${PATCH_HOME}/var/cache/apt/archives"
rsync -rav --delete --size-only  ${IMG}.ovrl/var/cache/apt/archives/ ${PATCH_HOME}/var/cache/apt/archives 


echo -n "removing unsued files ..."
# remove unused files
rm    ${IMG}.ovrl/var/cache/apt/archives/*.deb

#umount ${IMG}.ovrl/install
rm -r ${IMG}.ovrl/install

echo "ok"
#########################################################################

echo "ok"

###########################################################################
##########################################################################

# gen image and class name
VERSION=$(date +%Y-%m-%d-%H%M%S)
DATE=$(date +%Y%m%d)
if test "$FREE" = "0"; then
   IMAGE="puavo-os-nonfree-${IMG}-${VERSION}-amd64"
   CLASS="nonfree"
else
   IMAGE="puavo-os-freebee-${IMG}-${VERSION}-amd64"
   CLASS="freebee"
fi

#set image params

echo "${IMAGE}.img" > ${IMG}.ovrl/etc/puavo-image/name
echo "$( cat ${IMG}.ovrl/etc/puavo-image/release ) (v${DATE})">${IMG}.ovrl/etc/puavo-image/release 
echo "$CLASS" > ${IMG}.ovrl/etc/puavo-image/class

##make squashfs

echo -n "bulding  squash $IMAGE..."
mksquashfs ${IMG}.ovrl ${IMAGE}.img  -noappend -no-recovery
# more opts: -b 1048576 -comp xz

echo "ok"



echo "umounting ovrl and rofs"
umount ${IMG}.ovrl
umount ${IMG}.rofs




# bye
exit
