
target=$1
domain=$(echo $target | sed 's/\/.*//g' )
subdir=$(echo $target | sed 's/^[^\/]*//' | sed 's/[^\/]*\///' )
mkdir -p $domain

if [ $subdir ]
	then
	echo "Spidering a subdirectory $domain/$subdir"
	wget --no-parent -I $subdir -r -l0 -k -x --delete-after -t2 -o $domain.log $domain
	else
	echo "Spidering a whole domain $domain"
	wget --no-parent -r -l0 -k -x --delete-after -t2 -o $domain.log $domain
fi

grep -F $domain $domain.log | grep -o 'http:\/\/[^\ \"\(\)\<\>]*' | sed 's/\/$//' | sort | uniq > $domain.urls.txt

echo "DONE SPIDERING $domain"


