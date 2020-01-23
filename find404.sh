#!/bin/bash

cat "$@" | gawk '
	NF == 1 {LOCATION=$0; IDX=0; next} 
	$1 == 404 && $2 !~ /expressjs\.com/ { 
		LOCATIONS[LOCATION][IDX] = $2;
		BADURL[$2][LOCATION] ;
		IDX++
	} 
	END { 
		for (loc in LOCATIONS) {
			if (length(LOCATIONS[loc]) > 0) {
					print "404s on page " loc;
					for (url in LOCATIONS[loc]) {
						print "  " LOCATIONS[loc][url]
					}
			}
				}
			}
	'
