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
# avidemux fonts-crosextra-carlito fonts-crosextra-caladea youtube-dl  webfs 
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
                gnome-gmail 
                gnome-sound-recorder gnome-maps gnome-calendar
                font-manager california linphone"
       


# no proxy
#mv /etc/apt/apt.conf.d/00ltspbuild-proxy /etc/apt/00ltspbuild-proxy




echo -n "installiere Zusatzpakete ..."
# install extra packages

#apt-get ..........................
#apt-get --yes update



#gdrive
#add-apt-repository ppa:alessandro-strada/ppa


#owncloud
wget http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_14.04/Release.key
apt-key add - < Release.key
rm Release.key
3
echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud-client.list

#amxa 
echo 'deb http://archive.amxa.ch://ubuntu trusty main' >>/etc/apt/sources.list.d/amxa-archive.list

#avidemux
#echo 'deb http://www.deb-multimedia.org stretch main' >>/etc/apt/sources.list.d/multimedia-org.list
#apt-get install  --yes --allow-unauthenticated  deb-multimedia-keyring


#promethean
#wget http://activsoftware.co.uk/linux/repos/Promethean.asc -O promethean.key
#apt-key add promethean.key 

#cn=`lsb_release -c|awk '{print $2}'`

#echo 'deb http://activsoftware.co.uk/linux/repos/ubuntu trusty oss non-oss' >>/etc/apt/sources.list.d/promethean.list

#aseba for thymio
#add-apt-repository ppa:stephane.magnenat/`lsb_release -c -s`



#get them
apt-get --yes update
#apt-get --yes autoremove
#apt-get --yes upgrade

apt-get --yes install owncloud-client
#apt-get --yes install aseba
#apt-get --yes install google-drive-ocamlfuse
#apt-get --yes install deb-multimedia-keyring
#apt-get --yes --allow-unauthenticated  install avidemux
#apt-get --yes --allow-unauthenticated  install avidemux-qt

#apt-get --yes  install handbrake-gtk
apt-get --yes  install handbrake 

# install dependency for libdvdcss
DEBIAN_FRONTEND=noninteractive apt-get --yes  --force-yes install libdvd-pkg


#activinspire
#apt-get --yes install activinspire activinspire-help-de activresources-core-de activhwr-de

 


#from archive.amxa.ch
apt-get --yes --allow-unauthenticated install amxa-client-extra
apt-get --yes --allow-unauthenticated install lehreroffice-1.0
apt-get --yes --allow-unauthenticated install font-basisschrift
apt-get --yes --allow-unauthenticated install webapps
apt-get --yes --allow-unauthenticated install webmenu-editor
apt-get --yes --allow-unauthenticated install amxa-webmenu-extra
apt-get --yes --allow-unauthenticated -o Dpkg::Options::=--force-confnew  install amxa-webfs

#stretch only
apt-get --yes --allow-unauthenticated install amxa-puavo-os-art
apt-get --yes --allow-unauthenticated install amxa-client-media

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

#apt-get --yes -o Dpkg::Options::=--force-confnew -f install

#ls
# temp patches
#
#patches
ln -s /usr/bin/google-chrome-stable /usr/bin/chromium-browser


#libreoffice
for N in /usr/lib/libreoffice/share/xdg/*.desktop; do
    ln -s $N /usr/share/applications/libreoffice-$(basename ${N})
done

#packages

#activinspire
/install/packages/activinspire/install.sh
#openboard
/install/packages/openboard/install.sh
#eGalx Touchscreen
/install/packages/egalax/install.sh
#xmind
/install/packages/xmind/install.sh
# templates for lobreoffice
/install/packages/libreoffice/install.sh
# argos and amxa-xrand-clone plugin
/install/packages/argos/install.sh

#avidemux
#do not install avidemux, cause it makestroubles
#/install/packages/avidemux/install.sh
# install missing dependencies
DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::=--force-confnew --yes  --force-yes -f install


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
