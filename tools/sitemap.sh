
domain=$1
subdir=$(echo $domain | sed 's/.*\///' )
mkdir -p $domain
wget --no-parent -I$subdir -r -l0 -k -x --delete-after --spider -t3 -o $domain.log $domain
grep -F $domain $domain.log | grep -o 'http:\/\/[^\ \"\(\)\<\>]*' | sed 's/\/$//' | sort | uniq > $domain.urls.txt

echo "DONE SPIDERING $domain"


