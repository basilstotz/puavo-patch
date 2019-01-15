#!/bin/sh

# this runs in image chroot!!!!!!!!!!!!!!!!!!!!!!!!!!!

FREE="0"
if test "$1" = "free"; then
   FREE="1"
   echo "bulding free version..."
fi

WO="$(dirname $0)"
. $WO/config-stretch.sh

if test -z "$PASSWD"; then echo "pls set password!"; exit 1; fi

# processing extremetuxracer enigma fillets-ng  virt-manager pauker texlive-latex-extra gcompris-sound-en autossh libreoffice-l10n-fr libreoffice-l10n-de firefox-locale-en firefox-locale-de firefox-locale-fr unoconv debian-goodies 
# avidemux fonts-crosextra-carlito fonts-crosextra-caladea youtube-dl 
#gcompris-sound-de  gcompris-sound-en   rygel gnome-photoprinter 

# use tracker: gnome-documents gnome-photos gnome-music  

EXTRA_PACKAGES="xosview pdfshuffler pdftk djmount   
                texlive texlive-lang-german texlive-lang-french 
                texlive-lang-english 
                python-pypdf   rednotebook impressive 
                gnash gummi handbrake                             
		gcompris-sound-fr kodi 
                gparted sox key-mon screenkey dosemu 
                avahi-utils avahi-discover vokoscreen 
                photofilmstrip photocollage 
                gnome-sound-recorder gnome-maps gnome-calendar
                font-manager california linphone
                obs-studio webfs vde2
                minetest minetest-server minetest-mod-*"


# no proxy
#mv /etc/apt/apt.conf.d/00ltspbuild-proxy /etc/apt/00ltspbuild-proxy




echo -n "installiere Zusatzpakete ..."
# install extra packages

#apt-get ..........................
#apt-get --yes update




#get them
#cp /install/sources.list /etc/apt/.


#apt-get --yes update


  for N in $(ls /install/base-debs-stretch/*.deb); do
    echo
    echo "instaliere ${N} ..."
    echo

    dpkg  -i ${N}
  done

# install missing dependencies                                                  
apt-get --yes -f install



###############################################################3
for P in ${EXTRA_PACKAGES}; do
   apt-get --yes install ${P}
done

# install missing dependencies
DEBIAN_FRONTEND=noninteractive apt-get --yes  --force-yes install -f install

#apt-get --yes clean
#apt-get --yes autoclean

# restore proxy
#mv /etc/apt/00ltspbuild-proxy /etc/apt/apt.conf.d/00ltspbuild-proxy 

echo "ok"
echo

# install *.deb in /root/debs
for N in $(ls /install/debs-stretch/*.deb); do
   echo
   echo "instaliere ${N} ..."
   echo
   dpkg -i ${N}
 #  rm ${N}

done
echo "ok"

# install *.deb in /root/rdebs
if test "$FREE" -eq "0"; then
   for N in $(ls /install/rdebs/*.deb); do
      echo
      echo "instaliere ${N} ..."
      echo
      dpkg -i ${N}
      #  rm ${N}
   done
fi
echo "ok"


# install missing dependencies
# install missing dependencies
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::=--force-confnew --yes  --force-yes  -f install



#remove big not important packages
PURGEA=" extremetuxracer extremetuxracer-data extremetuxracer-extras  supertuxkart supertuxkart-data  xmoto xmoto-data neverball neverball-common neverball-data scribus-doc qt4-doc gimp-help-sv libreoffice-help-sv libreoffice-help-fi "
#remove unused texlive packages
PURGEB=" texlive-latex-extra-doc texlive-fonts-extra texlive-fonts-extra-doc texlive-pictures-doc texlive-pstricks-doc texlive-latex-base-doc texlive-latex-recommended-doc texlive-pstricks-doc "
#remove packages for secondary and ternary schools 
#PURGEC= "racket racket-common racket-doc fritzing fritzing-data globilab vstloggerpro cmaptools maxima tmcbeans pycharm maxima-doc "
PURGEC=" racket-doc maxima-doc " 
#
for N in $PURGEA $PURGEB $PURGEC; do
  apt-get --yes purge $N
done

#dpkg --list |grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge


#apt-get --yes autoremove
#apt-get --yes autoremove


echo "exiting chroot....."
exit
