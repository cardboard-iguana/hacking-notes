#!/usr/bin/env bash

# Make sure that required variables are set
#
if [[ -z "$FEED_TITLE" ]]; then
	echo "FEED_TITLE not set!"
	exit 1
fi
if [[ -z "$FEED_LINK" ]]; then
	echo "FEED_LINK not set!"
	exit 1
fi
if [[ -z "$FEED_DESCRIPTION" ]]; then
	echo "FEED_DESCRIPTION not set!"
	exit 1
fi
if [[ -z "$FEED_COPYRIGHT" ]]; then
	echo "FEED_COPYRIGHT not set!"
	exit 1
fi

# GitHub URLs
#
GITHUB_PREFIX="https://github.com/$GITHUB_REPOSITORY/blob/main"
RAW_PREFIX="https://github.com/$GITHUB_REPOSITORY/raw/main"

# Construct an array of timestamp + file name + file path
#
FILES_RAW=()

while IFS= read -d '' -r FILE; do
	# https://stackoverflow.com/a/2390382
	#
	FILES_RAW+=("$(git log --follow --format=%at "$FILE" | tail -1)|||$(basename "$FILE")|||$FILE")
done < <(find . -type f -iname '*.md' -not -iname 'README.md' -print0)

# Sort FILES_RAW array
#
# https://stackoverflow.com/a/11789688
#
IFS=$'\n' eval 'FILES_SORTED=($(sort <<< "${FILES_RAW[*]}"))'

# Determine publication date
#
# https://unix.stackexchange.com/a/503475
#
LAST_DATA="${FILES_SORTED[@]:(-1)}"
LAST_TIMESTAMP="$(echo -n "$LAST_DATA" | sed -r 's#\|\|\|.*##')"
LAST_PUBDATE="$(date --date="@$LAST_TIMESTAMP" "+%a, %d %b %Y %H:%M:%S %z")"

# Output RSS header
#
cat << EOF
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
	<channel>
		<title>$FEED_TITLE</title>
		<link>$FEED_LINK</link>
		<description>$FEED_DESCRIPTION</description>
		<copyright>$FEED_COPYRIGHT</copyright>
		<language>en-us</language>
		<atom:link href="https://github.com/$GITHUB_REPOSITORY/raw/main/feed.rss" rel="self" type="application/rss+xml" />
		<pubDate>$LAST_PUBDATE</pubDate>
		<lastBuildDate>$LAST_PUBDATE</lastBuildDate>
EOF

# Construct RSS <item/> for each markdown file
#
for DATA in "${FILES_SORTED[@]}"; do
	FILE="$(echo -n "$DATA" | sed -r 's#.*\|\|\|##')"
	TIMESTAMP="$(echo -n "$DATA" | sed -r 's#\|\|\|.*##')"

	# https://unix.stackexchange.com/a/552205
	#
	CONTENT="$(printf '%s\n' "$(cat "$FILE")" | sed '/./,$!d')"

	# https://unix.stackexchange.com/questions/159253/decoding-url-encoding-percent-encoding#comment424350_159254
	#
	BASENAME_ENCODED="$(basename "$FILE" ".md" | python3 -c "import sys, urllib.parse as ul; [sys.stdout.write(ul.quote_plus(l)) for l in sys.stdin]" | sed -r 's#\+#%20#g;s#%0A##g')"
	DIRNAME_ENCODED="$(dirname "$FILE" | sed -r 's#^\./##' | python3 -c "import sys, urllib.parse as ul; [sys.stdout.write(ul.quote_plus(l)) for l in sys.stdin]" | sed -r 's#\+#%20#g;s#%2F#/#g;s#%0A##g')"

	# Remove/set title
	#
	TITLE="$(echo -n "$CONTENT" | head -1)"
	if [[ "${TITLE:0:2}" == "# " ]]; then
		TITLE="$(echo -n "$TITLE" | sed -r 's/^# //')"
		CONTENT="$(printf '%s\n' "$(echo -n "$CONTENT" | tail -n +2)" | sed '/./,$!d')"
	else
		TITLE="$(basename "$FILE" ".md")"
	fi

	# Remove internal date, if it exists
	#
	if [[ $(echo -n "$CONTENT" | head -1 | grep -c "date:") -eq 1 ]]; then
		CONTENT="$(printf '%s\n' "$(echo -n "$CONTENT" | tail -n +2)" | sed '/./,$!d')"
	fi

	# RSS data
	#
	LINK="$GITHUB_PREFIX/$DIRNAME_ENCODED/$BASENAME_ENCODED.md"
	DESCRIPTION="$(echo -n "$CONTENT" | pandoc --from=gfm --to=html --wrap=none | sed -r "s#href=\"\.#href=\"$GITHUB_PREFIX/$DIRNAME_ENCODED/.#g;s#src=\"\.#src=\"$RAW_PREFIX/$DIRNAME_ENCODED/.#g;" | sed -r 's#&#\&amp;#g;s#"#\&quot;#g;s#<#\&lt;#g;s#>#\&gt;#g')"
	PUBDATE="$(date --date="@$TIMESTAMP" "+%a, %d %b %Y %H:%M:%S %z")"

	# Output RSS <item/>
	#
	cat << EOF
		<item>
			<title>$TITLE</title>
			<link>$LINK</link>
			<description>$DESCRIPTION</description>
			<pubDate>$PUBDATE</pubDate>
			<guid>$LINK</guid>
		</item>
EOF
done

# Output RSS footer
#
cat << EOF
	</channel>
</rss>
EOF
