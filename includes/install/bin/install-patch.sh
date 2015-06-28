#!/bin/sh

# this runs in image chroot!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Data
PASSWD=""

EXTRA_PACKAGES="xosview pdfshuffler pauker avidemux
                gummi  texlive texlive-lang-german texlive-lang-french texlive-lang-english texlive-latex-extra 
                extremetuxracer enigma fillets-ng python-pypdf youtube-dl 
                fonts-crosextra-carlito fonts-crosextra-caladea impressive autossh"

if test -z "$PASSWD"; then echo "pls set password!"; exit 1; fi

# Main

# set root passwd
echo "root:${PASSWD}" | chpasswd 

# no proxy
mv /etc/apt/apt.conf.d/00ltspbuild-proxy /etc/apt/00ltspbuild-proxy

echo -n "installiere Zusatzpakete ..."
# install extra packages

#apt-get ..........................
#apt-get --yes update

#apt-get --yes autoremove

wget http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_12.04/Release.key
apt-key add - < Release.key
rm Release.key

echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud-client.list"
apt-get update
apt-get --yes install owncloud-client




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

# update /opt/webmenu/menu-xdg.json

echo -n "updating webmenu ..."
cp /opt/webmenu/menu-default.json /etc/webmenu/menu.json
cp /opt/webmenu/menu-default.json /opt/webmenu/menu.json
cp /opt/webmenu/menu-default.json /etc/webmenu/personally-administered-device/menu.json

cp /opt/webmenu/config-default.json /etc/webmenu/config.json
cp /opt/webmenu/config-default.json /opt/webmenu/config.json


# LANGUAGE=de_CH webmenu | /usr/share/bin/webmenu-prepare.sh > /opt/webmenu/menu-xdg.json
echo "ok"
exit
