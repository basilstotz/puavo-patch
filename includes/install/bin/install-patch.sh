#!/bin/sh

# this runs in image chroot!!!!!!!!!!!!!!!!!!!!!!!!!!!

# Data
PASSWD="WaeGg,fsh."

# processing extremetuxracer enigma fillets-ng  virt-manager pauker texlive-latex-extra gcompris-sound-en

EXTRA_PACKAGES="xosview pdfshuffler pdftk djmount avidemux handbrake 
                gummi  texlive texlive-lang-german texlive-lang-french texlive-lang-english 
                python-pypdf youtube-dl gnash rygel  
                fonts-crosextra-carlito fonts-crosextra-caladea impressive autossh
		gcompris-sound-de gcompris-sounds-fr gcompris-sounds-en
                firefox-locale-en firefox-locale-de firefox-locale-fr
                gparted sox"
       

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
#apt-get --yes install activ-meta-de
apt-get --yes install aseba
#apt-get --yes install dropbox


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


# install missing dependencies
apt-get --yes -f install

#remove big not important packages
apt-get --yes remove extremetuxracer extremetuxracer-data extremetuxracer-extras  supertuxkart supertuxkart-data  xmoto xmoto-data neverball neverball-common neverball-data scribus-doc lilypond-doc-html liypond-doc-pdf qt4-doc ubunutu-docs gimp-help-sv libreoffice-help-sv libreoffice-helt-fi

#remove unused texlive packages
apt-get --yes remove texlive-latex-extra-doc texlive-fonts-extra texlive-fonts-extra-doc texlive-pictures-doc texlive-pstricks-doc texlive-latex-base-doc texlive-latex-recommended-doc texlive-pstricks-doc

#remove packages for secondary and ternary schools
apt-get --yes remove racket racket-common racket-doc fritzing fritzing-data globilab vstloggerpro cmaptools maxima tmcbeans pycharm maxima-doc 

#apt-get --yes autoremove
#apt-get --yes autoremove


#if test -e /etc/ltsp/this_ltspimage_name; then
# cp /etc/ltsp/this_ltspimage_name /etc/ltsp/base_ltspimage_name
#fi

# update /opt/webmenu/menu-xdg.json

#echo -n "updating webmenu ..."
#cp /opt/webmenu/menu-default.json /etc/webmenu/menu.json
#cp /opt/webmenu/menu-default.json /opt/webmenu/menu.json
#cp /opt/webmenu/menu-default.json /etc/webmenu/personally-administered-device/menu.json

#cp /opt/webmenu/config-default.json /etc/webmenu/config.json
#cp /opt/webmenu/config-default.json /opt/webmenu/config.json

#dirty fix for broken png
#rm /usr/share/pixmaps/plt*
#cp /usr/share/pixmaps/leo.png /usr/share/pixmaps/plt.png

#remove remote assistance app, for now
#rm /etc/xdg/autostart/puavo-remote-assistance-applet.desktop

#LANGUAGE=de webmenu-xdg | /usr/share/bin/webmenu-prepare.sh > /opt/webmenu/menu-xdg.json
#LANGUAGE=fr webmenu-xdg | /usr/share/bin/webmenu-prepare.sh > /opt/webmenu/menu-fr.xdg.json
#LANGUAGE=en webmenu-xdg | /usr/share/bin/webmenu-prepare.sh > /opt/webmenu/menu-en.xdg.json

echo "ok"
exit
