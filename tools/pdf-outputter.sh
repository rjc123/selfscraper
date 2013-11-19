
urls=$1
output="output"
cache="cache/docs"

for url in $(cat $urls)
do

	source=$(echo $url | sed 's/.*www/govuk/' | sed 's/[^.]*$/pdf/')
	target=$(echo $url | sed 's/.*www/www/' | sed 's/[^.]*$/pdf/')
	cp $cache/$source $output/$target
	git diff $output*

done