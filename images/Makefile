all:
	build
	publish

build:
	../puavo-patch/bin/patch.sh trusty|tee build.log

buildfree:
	../puavo-patch/bin/patch.sh trusty free|tee buildfree.log

gendiffs:
	./gendiffs.sh|tee gendiff.log

publish:
	./push-image.sh|tee publish.log 

