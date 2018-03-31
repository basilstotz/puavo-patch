#!/bin/sh

# this runs in image chroot!!!!!!!!!!!!!!!!!!!!!!!!!!!

FREE="0"
if test "$1" = "free"; then
   FREE="1"
   echo "bulding free version..."
fi

WO="$(dirname $0)"
. $WO/config-trusty.sh

if test -z "$PASSWD"; then echo "pls set password!"; exit 1; fi


# processing extremetuxracer enigma fillets-ng  virt-manager pauker texlive-latex-extra gcompris-sound-en autossh libreoffice-l10n-fr libreoffice-l10n-de firefox-locale-en firefox-locale-de firefox-locale-fr unoconv debian-goodies 

EXTRA_PACKAGES="xosview pdfshuffler pdftk djmount avidemux handbrake texlive  
                texlive-lang-german texlive-lang-french texlive-lang-english 
                python-pypdf youtube-dl gnash rygel gummi  rednotebook
                fonts-crosextra-carlito fonts-crosextra-caladea impressive
		gcompris-sound-de gcompris-sound-fr gcompris-sound-en
                gparted sox key-mon screenkey dosemu 
                minetest minetest-server minetest-mod-*"
       


# Main

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

#obs
add-apt-repository --yes ppa:kirillshkrogalev/ffmpeg-next
add-apt-repository --yes ppa:obsproject/obs-studio



#promethean
#wget http://activsoftware.co.uk/linux/repos/Promethean.asc -O promethean.key
apt-key add promethean.key 

cn=`lsb_release -c|awk '{print $2}'`

#echo 'deb http://activsoftware.co.uk/linux/repos/ubuntu precise oss non-oss' >>/etc/apt/sources.list.d/promethean.list

#aseba for thymio

# temp fixed on 1.5.5 
add-apt-repository --yes ppa:stephane.magnenat/`lsb_release -c -s`



#get them
apt-get --yes update
#apt-get --yes autoremove
#apt-get --yes upgrade

apt-get --yes install owncloud-client
apt-get --yes install aseba
apt-get --yes install google-drive-ocamlfuse
apt-get --yes install ffmpeg
apt-get --yes install obs-studio

cp /usr/share/applications/obs.desktop /usr/share/applications/obs-studio.desktop


#apt-get --yes install activinspire activinspire-help-de activresources-core-de activhwr-de

# install *.deb in activ-trusty
for N in $(ls /install/activ-trusty/*.deb); do
   echo
   echo "instaliere ${N} ..."
   echo

   dpkg  -i ${N}

done

# install missing dependencies
apt-get --yes -f install

echo "ok"


if false; then
  #from archive.amxa.ch
  apt-get --yes --allow-unauthenticated install amxa-client-extra
  apt-get --yes --allow-unauthenticated install lehreroffice-1.0
  apt-get --yes --allow-unauthenticated install font-basisschrift
  apt-get --yes --allow-unauthenticated install webapps
  #apt-get --yes --allow-unauthenticated install webmenu-editor
  apt-get --yes --allow-unauthenticated install amxa-webmenu-extra
  #apt-get --yes --allow-unauthenticated install amxa-client-media
  apt-get --yes --allow-unauthenticated -o Dpkg::Options::=--force-confnew  install amxa-webfs
else
apt-get --yes install webfs
  for N in $(ls /install/base-debs/*.deb); do
    echo
    echo "instaliere ${N} ..."
    echo
 
    dpkg  -i ${N}
  done
fi  

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

   dpkg --force-confnew -i ${N}

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

apt-get --yes -o Dpkg::Options::=--force-confnew -f install

#put webapps in path (is this allready in deb?)
ln -s /usr/share/bin/webapps /usr/bin/webapps

#link icons to be compliant with stretch
mkdir -p /usr/share/icons/oxygen/base/
ln -s /usr/share/icons/oxygen/64x64 /usr/share/icons/oxygen/base/

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
