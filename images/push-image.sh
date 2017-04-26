#!/bin/sh


SERIES="amxa"

ID=" -i ssh/id_dsa "
SSH_OPT=" -e ' ssh -i ssh/id_dsa ' "
SERVER="root@images.amxa.ch"


OK="false"
#get_rdiff_filename() {
#  previous_image_name=$IMAGE
#  next_image_name=$2

#  echo "$previous_image_name $next_image_name" \
#    | awk '
#        NR == 1 {
#	  orig   = $IMAGE
#	  target = $2
#	  regex  = "^(.*?)-([0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6})-(.*?).img$"
     
#	  if (match(orig, regex, orig_match) \
#	    && match(target, regex, target_match)) {
#	      printf("%s-%s--%s-%s.rdiff\n",
#		     orig_match[1],
#		     orig_match[2],
#		     target_match[2],
#		     orig_match[3])
#	      exit(0)
#	  }
#	  else { exit(1) }
#	}
#      '
#}

ssh $ID $SERVER touch /opt/ltsp/images/NOTOK

EXT=$(ssh $ID $SERVER "ls -t /opt/ltsp/images/ltsp-$SERIES-*-i386.img" | head -n1)
EXTERN=$(basename $EXT)


if test -n "$1"; then
  IMAGE=$1
else
#  IMAGE=$(latest-image)
  IMAGE=$(ls -t ltsp-$SERIES-*-i386.img|head -n1)
fi



echo "--$EXTERN---$IMAGE--"

#cd /home/images/www/


if test "$EXTERN" = "$IMAGE"; then
  echo "same file"
else
  RDIFF=$(amxa-rdiff-filename  $EXTERN $IMAGE)
  echo $RDIFF
  if ! test -e rdiffs/$RDIFF; then
     echo -n "make rdiff ..."
     amxa-generate-rdiff $EXTERN $IMAGE
     echo "ok"
  fi

  echo "$IMAGE" >>images.list
  cat images.list|tail -n 20>images.neu
  cp images.neu images.list
fi


rsync -e "ssh -i ssh/id_dsa " -avr rdiffs/$RDIFF $SERVER:/opt/ltsp/images/rdiffs/.
#scp $ID  rdiffs/* $SERVER:/home/images/www/rdiffs/.

#if test -e CKSUMS; then
#  scp $ID CKSUMS $SERVER:/home/images/www/.
#  scp $ID CKSUMS $SERVER:/home/images/www/rdiffs/.
#fi

#if test -e meta/ltsp-amxa-trusty-i386.json; then
#  ssh $ID $SERVER if ! test -d /home/images/www/meta;then mkdir -p /home/images/www/meta 
#  scp $ID meta/ltsp-amxa-trusty-i386.json $SERVER:/home/images/www/meta/.
#fi

if ! test -e $IMAGE.cksum; then
  cksum $IMAGE >$IMAGE.cksum
fi
scp $ID $IMAGE.cksum $SERVER:/opt/ltsp/images/.


if ! test -e $IMAGE.sha256; then
   sha256sum $IMAGE >$IMAGE.sha256
fi 
scp $ID $IMAGE.sha256 $SERVER:/opt/ltsp/images/.


#if ! test -e $IMAGE.zsync; then
#   zsyncmake $IMAGE -u $IMAGE   
#fi
#rsync -e "ssh -i ssh/id_dsa " -avr $IMAGE.zsync $SERVER:/home/images/www/.
#scp $ID $IMAGE.zsync $SERVER:/home/images/www/.


#image
echo -n "external patch command ..."
if ! test "$EXTERN" = "$IMAGE";then
  ssh $ID $SERVER rdiff patch /opt/ltsp/images/$EXTERN /opt/ltsp/images/rdiffs/$RDIFF /opt/ltsp/images/$IMAGE
fi
echo "ok"

# cleanup
#ssh $ID $SERVER "if test -e /home/images/www/$IMAGE.zsync; then rm /home/images/www/$IMAGE.zsync; fi"
echo -n "external post upload command ..."  
  ssh $ID $SERVER "amxa-imageserver-post-upload $SERIES&"
  ssh $ID $SERVER rm /opt/ltsp/images/NOTOK
echo "ok"

exit

# rdiffs
#echo "preparing $RDIFF..."
if false; then
#if ! test -e rdiffs/$RDIFF; then
   echo "$RDIFF not found. Building..."

   if ! test -e $EXTERN.sig; then
       echo "building signature..."
       if rdiff signature $EXTERN $EXTERN.sig.tmp; then
          mv $EXTERN.sig.tmp $EXTERN.sig
       fi
   fi
   echo "building rdiff"
   if ! test -e $RDIFF; then
      if rdiff delta $EXTERN.sig $IMAGE rdiffs/$RDIFF.tmp; then
         mv rdiffs/$RDIFF.tmp rdiffs/$RDIFF
         cd rdiffs
         cksum $RDIFF > $RDIFF.cksum
         sha256sum $RDIFF > $RDIFF.sha256
         cd ..
         OK="true"
      fi
   fi
fi



