x1#!/bin/sh

# this runs in image chroot!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Data
PASSWD="WaeGg,fsh."

# processing extremetuxracer enigma fillets-ng  virt-manager pauker texlive-latex-extra gcompris-sound-fr gcompris-sound-en

EXTRA_PACKAGES="xosview pdfshuffler avidemux handbrake 
                gummi  texlive texlive-lang-german texlive-lang-french texlive-lang-english 
                python-pypdf youtube-dl 
                fonts-crosextra-carlito fonts-crosextra-caladea impressive autossh
		gcompris-sound-de "

if test -z "$PASSWD"; then echo "pls set password!"; exit 1; fi

# Main

#amxa-client-extra
update-rc.d clean-images defaults
update-rc.d update-images defaults
chmod +s /usr/local/bin/amxa-client-http-filter


# set root passwd
echo "root:${PASSWD}" | chpasswd 

# no proxy
mv /etc/apt/apt.conf.d/00ltspbuild-proxy /etc/apt/00ltspbuild-proxy

echo -n "installiere Zusatzpakete ..."
# install extra packages

#apt-get ..........................
#apt-get --yes update

#apt-get --yes autoremove

wget http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_14.04/Release.key
apt-key add - < Release.key
rm Release.key

echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/desktop/Ubuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud-client.list
echo 'deb http://archive.amxa.ch://ubuntu trusty main' >>/etc/apt/sources.list.d/amxa-archive.list


apt-get --yes update
#apt-get --yes autoremove
#apt-get --yes upgrade

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

# install missing dependencies
apt-get --yes -f install

#remove big not important packages
apt-get --yes remove extremetuxracer supertuxkart extremetuxracer-data extremetuxracer-extras supertuxkart-data  maxima tmcbeans pycharm texlive-latex-extra-doc texlive-font-extra texlive-pictures-doc texlive-pstricks-doc xmoto xmoto-data

#remove packages for secondary and ternary schools
apt-get remove racket racket-common racket-doc fritzing fritzing-data globilab vstloggerpro cmaptools 


if test -e /etc/ltsp/this_ltspimage_name; then
 cp /etc/ltsp/this_ltspimage_name /etc/ltsp/base_ltspimage_name
fi

# update /opt/webmenu/menu-xdg.json

echo -n "updating webmenu ..."
cp /opt/webmenu/menu-default.json /etc/webmenu/menu.json
cp /opt/webmenu/menu-default.json /opt/webmenu/menu.json
cp /opt/webmenu/menu-default.json /etc/webmenu/personally-administered-device/menu.json

cp /opt/webmenu/config-default.json /etc/webmenu/config.json
cp /opt/webmenu/config-default.json /opt/webmenu/config.json

#dirty fix for broken png
rm /usr/share/pixmaps/plt*
cp /usr/share/pixmaps/leo.png /usr/share/pixmaps/plt.png

#remove remote assistance app, for now
rm /etc/xdg/autostart/puavo-remote-assistance-applet.desktop

# LANGUAGE=de_CH webmenu | /usr/share/bin/webmenu-prepare.sh > /opt/webmenu/menu-xdg.json
echo "ok"
exit
