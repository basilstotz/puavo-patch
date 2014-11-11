#!/bin/sh

# Data
PASSWD="WaeGg,fsh."
EXTRA_PACKAGES="xosview pdfshuffler gummi extremetuxracer enigma cultivation fillets-ng python-pypdf"


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


exit
