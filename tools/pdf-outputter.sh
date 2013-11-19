
urls=$1
output="output"
cache="cache/docs"

for url in $(cat $urls)
do

	source=$(echo $url | sed 's/.*www/govuk/' | sed 's/[^.]*$/pdf/')
	target=$(echo $url | sed 's/.*www/www/' | sed 's/[^.]*$/pdf/')
	mkdir -p $output/$(echo $target | sed 's/[^\/]*$//')
	cp -v -a -f $cache/$source $output/$target
done

git add $output*
git commit -m "New copies of PDFs in output from $urls"
