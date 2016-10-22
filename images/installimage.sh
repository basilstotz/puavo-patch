#!/bin/sh
puavo-install-and-update-ltspimages --install-from-file $1 $(basename $1 .img)
