#!/bin/sh

ID=" -i ssh/id_dsa "

get_rdiff_filename() {
  previous_image_name=$1
  next_image_name=$2

  echo "$previous_image_name $next_image_name" \
    | awk '
        NR == 1 {
	  orig   = $1
	  target = $2
	  regex  = "^(.*?)-([0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{6})-(.*?).img$"
     
	  if (match(orig, regex, orig_match) \
	    && match(target, regex, target_match)) {
	      printf("%s-%s--%s-%s.rdiff\n",
		     orig_match[1],
		     orig_match[2],
		     target_match[2],
		     orig_match[3])
	      exit(0)
	  }
	  else { exit(1) }
	}
      '
}


EXT=$(ssh $ID root@hadar.amxa.ch "ls -t /home/images/www/ltsp-amxa-*-i386.img" | head -n1)

EXTERN=$(basename $EXT)

echo $EXTERN $1

#cd /home/images/www/

if ! test -e $1; then
  echo "$1 not found"
  exit
fi
if ! test -e $EXTERN; then
  echo "$EXTERN not found"
  exit
fi

RDIFF=$(get_rdiff_filename $EXTERN $1)

echo $RDIFF


# rdiffs
echo "preparing $RDIFF..."
if ! test -e rdiffs/$RDIFF; then
   echo "$RDIFF not found. Building..."

   if ! test -e $EXTERN.sig; then
       echo "building signature..."
       rdiff signature $EXTERN $EXTERN.sig
   fi
   echo "building rdiff"
   rdiff delta $EXTERN.sig $1 rdiffs/$RDIFF
   cksum rdiffs/$RDIFF > rdiffs/$RDIFF.cksum
fi
scp $ID rdiffs/$RDIFF* root@hadar.amxa.ch:/home/images/www/rdiffs/.

#cksum
if ! test -e $1.cksum; then
  cksum $1 >$1.cksum
fi
scp $ID $1.cksum root@hadar.amxa.ch:/home/images/www/.

#image
ssh $ID root@hadar.amxa.ch rdiff patch /home/images/www/$EXTERN /home/images/www/rdiffs/$RDIFF /home/images/www/$1

#cleanup
#ssh $ID root@hadar.amxa.ch "if test -e /home/images/www/$1.zsync; then rm /home/images/www/$1.zsync; fi"
ssh $ID root@hadar.amxa.ch /home/images/bin/update-images




