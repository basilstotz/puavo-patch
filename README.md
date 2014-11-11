puavo-patch
===========

to be placed on bootserver!!!


## Installation

 cd /var/lib/
 git clone https://github.com/basilstotz/puavo-patch.git


## Preparation
 // you might want to edit PASSWD and EXTRA_PACKAGES
 emacs includes/install/bin/install-patch.sh

 // copy local debs
 cp /path/to/debs/* includes/install/debs/

## Patch

  // nice, not necessary
  cd /opt/ltsp/images/
  /var/lib/puavo-patch/bin/patch.sh IMAGE  (without .img!)


