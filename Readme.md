# Expressjs.com Link Checker

This action crawls the live [expressjs.com](https://expressjs.com) website and checks external links to see if they return a 404.

## Uses

Currently using a tool called [muffet](https://github.com/raviqqe/muffet) to check the links. It is faster by a lot than [broken-link-checker](https://github.com/stevenvachon/broken-link-checker), which is JS based CLI and library for checking links. (I would prefer to use the JS solution, but that project currently has some unresolved bugs which make it sometimes hang and never complete.)

The command I'm using to check links with muffet is:

```sh
muffet -c 100 -t 30 https://expressjs.com
```

- `-c` limit concurrent connections to 100 (I had issues with timeouts when it was using its default 524)
- `-t` wait up to 30 seconds before timing out a connection

### Parsing output

Muffet checks for a lot more than 404s, it checks if anchors aren't present on a page that was linked to with an anchor (`http://url.com/index.html#my-anchor`) and checks for redirects. But currently I only care about checking 404s.

Because muffet doesn't have a way to only check for 404s, and the output syntax duplicates URLs which are bad, I feed the output through `gawk` to grab only 404 errors:

```
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
```

This displays unique Bad URLs, and lists on what page each Bad URL is found. Most URLs are repeated across translations on the express site, so this gives you the unique value (the Bad URL), and all the pages that need to be updated.

That output looks like this:

```
404 - https://nodejs.org/api/cluster.html.
found on:
  expressjs.com/ja/advanced/best-practice-performance.html
404 - http://strongloop.com/strongblog/category/express/
found on:
  expressjs.com/de/resources/books-blogs.html
  expressjs.com/ko/resources/books-blogs.html
  expressjs.com/zh-tw/resources/books-blogs.html
  expressjs.com/sk/resources/books-blogs.html
  expressjs.com/uz/resources/books-blogs.html
  expressjs.com/fr/resources/books-blogs.html
```

## Github Action

Yeah, iBad t's broken right now ¯\_(ツ)\_/¯
