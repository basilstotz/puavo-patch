#!/bin/sh

# this runs in image chroot!!!!!!!!!!!!!!!!!!!!!!!!!!!

FREE="0"
if test "$1" = "free"; then
   FREE="1"
   echo "bulding free version..."
fi



# Data
PASSWD=""

# processing extremetuxracer enigma fillets-ng  virt-manager pauker texlive-latex-extra gcompris-sound-en

EXTRA_PACKAGES="xosview pdfshuffler pdftk djmount avidemux handbrake 
                gummi  texlive texlive-lang-german texlive-lang-french texlive-lang-english 
                python-pypdf youtube-dl gnash rygel  
                fonts-crosextra-carlito fonts-crosextra-caladea impressive autossh 
		gcompris-sound-de gcompris-sounds-fr gcompris-sounds-en
                firefox-locale-en firefox-locale-de firefox-locale-fr
                gparted sox debian-goodies unoconv key-mon screenkey"
       

if test -z "$PASSWD"; then echo "pls set password!"; exit 1; fi

# Main

###########################to be moved to deb package#################33
# set root passwd
echo "root:${PASSWD}" | chpasswd 


# no proxy
mv /etc/apt/apt.conf.d/00ltspbuild-proxy /etc/apt/00ltspbuild-proxy




echo -n "installiere Zusatzpakete ..."
# install extra packages

#apt-get ..........................
#apt-get --yes update



#gdrive
add-apt-repository ppa:alessandro-strada/ppa


#owncloud
wget http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_14.04/Release.key
apt-key add - < Release.key
rm Release.key

echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud-client.list

#amxa 
echo 'deb http://archive.amxa.ch://ubuntu trusty main' >>/etc/apt/sources.list.d/amxa-archive.list

#promethean
wget http://activsoftware.co.uk/linux/repos/Promethean.asc -O promethean.key
apt-key add promethean.key 

cn=`lsb_release -c|awk '{print $2}'`

echo 'deb http://activsoftware.co.uk/linux/repos/ubuntu trusty oss non-oss' >>/etc/apt/sources.list.d/promethean.list

#aseba for thymio
add-apt-repository ppa:stephane.magnenat/`lsb_release -c -s`



#get them
apt-get --yes update
#apt-get --yes autoremove
#apt-get --yes upgrade

apt-get --yes install owncloud-client
apt-get --yes install aseba
apt-get --yes install google-drive-ocamlfuse


if test "$FREE" = "0"; then
  apt-get --yes install activ-meta-de
fi


#from archive.amxa.ch
apt-get --yes --allow-unauthenticated install amxa-client-extra
apt-get --yes --allow-unauthenticated install lehreroffice-1.0
apt-get --yes --allow-unauthenticated install font-basisschrift
apt-get --yes --allow-unauthenticated install webapps
apt-get --yes --allow-unauthenticated install webmenu-editor
apt-get --yes --allow-unauthenticated install amxa-webmenu-extra

###############################################################3
for P in ${EXTRA_PACKAGES}; do
   apt-get --yes install ${P}
done

# install missing dependencies
apt-get --yes -f install

#apt-get --yes clean
#apt-get --yes autoclean

# restore proxy
mv /etc/apt/00ltspbuild-proxy /etc/apt/apt.conf.d/00ltspbuild-proxy 
echo "ok"
echo

# install *.deb in /root/debs
for N in $(ls /install/debs/*.deb); do
   echo
   echo "instaliere ${N} ..."
   echo
   dpkg -i ${N}
 #  rm ${N}
done
echo "ok"

# install *.deb in /root/debs
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
apt-get --yes -f install

#remove big not important packages
PURGEA=" extremetuxracer extremetuxracer-data extremetuxracer-extras  supertuxkart supertuxkart-data  xmoto xmoto-data neverball neverball-common neverball-data scribus-doc qt4-doc gimp-help-sv libreoffice-help-sv libreoffice-help-fi "
#remove unused texlive packages
PURGEB=" texlive-latex-extra-doc texlive-fonts-extra texlive-fonts-extra-doc texlive-pictures-doc texlive-pstricks-doc texlive-latex-base-doc texlive-latex-recommended-doc texlive-pstricks-doc "
#remove packages for secondary and ternary schools 
#PURGEC= "racket racket-common racket-doc fritzing fritzing-data globilab vstloggerpro cmaptools maxima tmcbeans pycharm maxima-doc "
PURGEC= " racket-doc maxima-doc " 
#
for N in $PURGEA $PURGEB $PURGEC; do
  apt-get --yes purge $N
done

#dpkg --list |grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge


#apt-get --yes autoremove
#apt-get --yes autoremove


echo "ok"
exit
