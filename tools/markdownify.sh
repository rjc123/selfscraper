
#Use spider.sh to get a markdownified version of the url list you've already got.

sed 's/www\./fuckyeahmarkdown\.com\/go\/\?read\=1\&preview\=0\&showframe\=0\&u\=http\:\/\/www\./g' $1 > tmptodo
sh tools/spider.sh tmptodo
