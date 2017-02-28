#!/bin/sh

# this runs in image chroot!!!!!!!!!!!!!!!!!!!!!!!!!!!


# no proxy
#mv /etc/apt/apt.conf.d/00ltspbuild-proxy /etc/apt/00ltspbuild-proxy


echo -n "installiere restricted Zusatzpakete ..."

# install missing dependencies
apt-get --yes -f install

#apt-get --yes clean
#apt-get --yes autoclean

# restore proxy
#mv /etc/apt/00ltspbuild-proxy /etc/apt/apt.conf.d/00ltspbuild-proxy 
echo "ok"
echo

# install *.deb in /root/debs
for N in $(ls /install/rdebs/*.deb); do
   echo
   echo "instaliere ${N} ..."
   echo
   dpkg -i ${N}
 #  rm ${N}
done
echo "ok"


# install missing dependencies
apt-get --yes -f install

#remove big not important big packages
PURGEA=" extremetuxracer extremetuxracer-data extremetuxracer-extras  supertuxkart supertuxkart-data  xmoto xmoto-data neverball neverball-common neverball-data scribus-doc qt4-doc gimp-help-sv libreoffice-help-sv libreoffice-help-fi "
#remove unused texlive packages
#PURGEB=" texlive-latex-extra-doc texlive-fonts-extra texlive-fonts-extra-doc texlive-pictures-doc texlive-pstricks-doc texlive-latex-base-doc texlive-latex-recommended-doc texlive-pstricks-doc "
#remove big packages for secondary and ternary schools 
PURGEC= "racket racket-common racket-doc fritzing fritzing-data globilab vstloggerpro cmaptools maxima tmcbeans pycharm maxima-doc " 
#
for N in $PURGEA $PURGEB $PURGEC; do
  apt-get --yes purge $N
done
dpkg --list |grep "^rc" | cut -d " " -f 3 | xargs sudo dpkg --purge


echo "ok"
exit
