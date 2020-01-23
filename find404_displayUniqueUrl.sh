#!/bin/bash

muffet -c 100 -t 30 https://expressjs.com | gawk '
NF == 1 {
	LOCATION = $0;
	sub(/(http|https):\/\//, "", LOCATION);
	next
} 
# check for external links that 404
$1 == 404 && $2 !~ /expressjs\.com/ { 
	BADURL[$2][LOCATION] = LOCATION ;
} 
END { 
	for (url in BADURL) {
				print "404 - " url;
				print "found on:"
				for (loc in BADURL[url]) {
					print "  " BADURL[url][loc]
				}
			}
		}
	'
