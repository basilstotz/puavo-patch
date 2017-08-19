#!/bin/sh

find . -maxdepth 1 -executable -type f -exec cp \{\} ../puavo-patch/images/. \;
cp Makefile ../puavo-patch/images/.

