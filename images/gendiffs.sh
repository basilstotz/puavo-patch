#!/bin/sh

cd /mnt/images/

HEAD=$(ls -r ltsp-amxa-*-i386.img|head -n1)
#ALL=$(ls -r ltsp-amxa-*-i386.img)

ALL=$(cat images.list|tail -n8)

echo $HEAD
echo $ALL

#      echo $PREV $NEW
      PRE=$(echo $PREV|cut -d- -f1-3)
#     POST=$(echo $PREV|cut -d- -f8)
      POST="i386.rdiff"
      FIRST=$(echo $PREV|cut -d- -f4-7)
      SECOND=$(echo $HEAD|cut -d- -f4-7)
      RDIFF_PATTERN="*--${SECOND}-${POST}"

echo $RDIFFPATTERN
      
HOLD=$(ls rdiffs/$RDIFF_PATTERN)
for N in $(ls rdiffs/ltsp-amxa-*.rdiff); do
  if echo $HOLD|grep -q $N; then
    echo "keep it. $N"
  else
    echo "move it: $N"
    mv $N* rdiffs-alt/.
  fi
done
#mv rdiffs/* rdiffs-alt/



for OLD in $ALL; do
  if ! test "$HEAD" = "$OLD"; then
     if ! test -e rdiffs/$OLD; then
       while test "$(ps aux|grep 'rdiff delta'|grep -v grep|wc -l)" -gt 3; do
          #echo -n "*"
          sleep 60
       done
       amxa-generate-rdiff $OLD $HEAD &
       sleep 2
     else
       echo "$OLD existiert schon"
     fi
  fi
done
while test "$(ps aux|grep 'rdiff delta'|grep -v grep|wc -l)" -gt 0; do
  #echo -n "*"
  sleep 60
done

amxa-generate-cksums .
if ! test -d meta; then mkdir meta;fi
amxa-generate-images-meta . one >meta/ltsp-amxa-trusty-i386.json

