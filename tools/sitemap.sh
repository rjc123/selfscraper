
domain=$1
subdir=$(echo $domain | sed 's/.*\///' )
mkdir -p $domain

if [ $subdir ]
	then
	echo "Spidering a subdirectory $subdir"
	wget --no-parent -I $subdir -r -l0 -k -x --delete-after --spider -t2 -o $domain.log $domain
	else
	echo "Spidering a whole domain, with $subdir as a subdir"
	wget --no-parent -r -l0 -k -x --delete-after --spider -t2 -o $domain.log $domain
fi

grep -F $domain $domain.log | grep -o 'http:\/\/[^\ \"\(\)\<\>]*' | sed 's/\/$//' | sort | uniq > $domain.urls.txt

echo "DONE SPIDERING $domain"


