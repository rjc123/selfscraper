
domain=$1
mkdir -p $domain
wget -np -r -l0 -k -x --delete-after -T1 --spider -o $domain.log $domain
grep -F $domain $domain.log | grep -o 'http:\/\/[^\ \"\(\)\<\>]*' | sort | uniq > $domain.urls.txt

echo "DONE SPIDERING $domain"


